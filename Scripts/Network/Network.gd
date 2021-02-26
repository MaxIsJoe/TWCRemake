extends Node

const DEFAULT_PORT = 31416
const DEFAULT_IP = '127.0.0.1'
const MAX_PLAYERS    = 127

onready var PlayerContainer = $Container

var world_data = {}
var world_state = {}
remotesync var ActiveKeys = {}
remotesync var spells_ID = -1


var last_world_state = 0

signal player_disconnected
signal server_disconnected

func _ready():
	#Connect signals
	get_tree().connect('network_peer_disconnected', self, '_on_player_disconnected')
	get_tree().connect('network_peer_connected', self, '_on_player_connected')
	#Create the container that will have the players
	
func create_server():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)
	set_network_master(1)
	print(str("[Networking]: Server created // Server IP -> " + DEFAULT_IP))
	world_state["T"] = OS.get_system_time_msecs() #(Max): I don't remember why I needed to set a timestamp this early but the game throws an error randomly if I don't so I'm leaving this here.
	set_physics_process(true)
	Engine.set_iterations_per_second(20) #This is to make the server send calls 20 times per second instead of 60

func connect_to_server():
	get_tree().connect('connected_to_server', self, '_connected_to_server')
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(DEFAULT_IP, DEFAULT_PORT)
	get_tree().set_network_peer(peer)
	world_state["T"] = OS.get_system_time_msecs()

func _connected_to_server():
	var local_player_id = get_tree().get_network_unique_id()
	print("[Networking]: Connected to server as", local_player_id ,". Loading game..")
	world_state["T"] = OS.get_system_time_msecs()
	Data.main_node.ShowLoginScreen()

func _on_player_disconnected(id):
	print(str("[Networking]: " + str(id) + " disconnected."))
	if(get_tree().get_network_unique_id() != 1): 
		if(PlayerContainer.get_child_count() > 0): 
			Data.main_node.UI_Chat.SendText(0, PlayerContainer.get_node(str(id)).PlayerName + " logged off.", "") #If there is at least one other player on the server, tell them who logged off
	else:
		RemovePlayerID(id)
	world_state.erase(id)
	world_data.erase(id)
	NetworkManager.Functions.rpc("RemovePlayerFromWorld", id) #Remove the player id from all clients and server
	if(Global.DEBUG_Mode):
		print("\n[Networking] - World State ->", world_state) #Server side debugging
		print("\n[Networking] - World State Size ->", str(world_state.size())) #Server side debugging
	
func _on_player_connected(connected_player_id):
	print("[Networking] - player_connected:", connected_player_id)
	if(Global.DEBUG_Mode):
		print("\n[Networking] - Check Wolrd_State ->", world_state)
		print("\n[Networking] - World State Size ->", str(world_state.size())) #Server side debugging
	if not(get_tree().is_network_server()):
		rpc_id(1, 'GetWorldState', world_state)

remotesync func SendData(state):
	var playerID = get_tree().get_rpc_sender_id()
	if(world_data.has(playerID)):
		if(world_data[playerID]["T"] < state["T"]):
			world_data[playerID] = state
	else:
		world_data[playerID] = state

func SendWorldState(state):
	if(is_network_master()):
		rpc_unreliable_id(0, "GetWorldState", state)
	
remotesync func GetWorldState(state):
	###NOTE: Do NOT print anything here for any reason.###
	###If you do,then remove it before pushing a change###
	if(!state.empty()):
		if state["T"] > last_world_state:
			last_world_state = state["T"]
			state.erase("T")
			state.erase(1) #This prevents the server from creating an empty player
			state.erase(get_tree().get_network_unique_id()) #This removes the client from the list so we can focus on the other players
			for player in state.keys():
				if(PlayerContainer.has_node(str(player))): #Checks if the player exists on the client side
					PlayerContainer.get_node(str(player)).UpdatePlayer(state[player]["P"], state[player]["A"], state[player]["LD"], state[player]["D"], state[player]["SP"])

remote func CreateActivePlayers(id): #Creates all players on the server on the client
	for player in ActiveKeys:
		if(player == PlayerContainer.get_node(str(id)).playerkey): return #So we don't create doubles of the player
		var file = File.new()
		file.open(str("user://saves/" + player + ".json"), File.READ)
		var dfile = file.get_as_text()
		var data = parse_json(dfile)
		NetworkManager.Functions.rpc_id(id, "CreateThePlayer", data["N"], int(data["G"]), int(data["H"]), null, Vector2(int(data["vx"]), int(data["vy"])), int(ActiveKeys[player]["ID"])) #Tell the client to create this player with their correct data
		file.close()
		
remote func GetSavedPlayerData(key, id): #Sends the player's savefile to him, the savefile *should* only exist on the server.
	var file = File.new()
	file.open(str("user://saves/" + key + ".json"), File.READ)
	var dfile = file.get_as_text()
	var data = parse_json(dfile)
	Data.main_node.MainMenu.rset_id(id, "saveddata", data)
	file.close()

remote func SetSpellState():
	spells_ID += 1
	rset_id(0, "spells_ID", spells_ID)
	
remote func SendSpellState():
	rpc("SetSpellState")

func RemovePlayerID(id): #Responisble for erasing the player key and making sure it's no longer in world_state
	SavePlayer(id)
	RemoveActiveKey(PlayerContainer.get_node(str(id)).playerkey)
	if(world_state.has(id)): world_state.erase(id)
	if(Global.DEBUG_Mode): print("Removed player ID")
	
remotesync func GetActiveKeys(): #Tell all clients what clients are online and playing right now.
	rset_id(0, "ActiveKeys", ActiveKeys)

remote func AddActiveKey(key): #Add player who's actively playing right now
	var online_id = get_tree().get_rpc_sender_id()
	ActiveKeys[key] = {"ID": online_id}
	GetActiveKeys()
	
func RemoveActiveKey(key): #Remove a key that belongs to a player who is no longer connected.
	ActiveKeys.erase(key)
	GetActiveKeys()

func _physics_process(delta):
	if not world_data.empty():
		world_state = world_data.duplicate(true)
		for player in world_state.keys():
			world_state[player].erase("T")
		world_state["T"] = OS.get_system_time_msecs()
		SendWorldState(world_state)

func SavePlayer(id):
	var playerdata = PlayerContainer.get_node(str(id)).GetSavePlayerInfo()
	JsonLoader.SaveJSON(playerdata, str("user://saves/" + str(playerdata.get("key")) + ".json"))
	if(Global.DEBUG_Mode): print(str("Hey shitass, I'm saving " + playerdata["N"] + " under key -> " + str(playerdata.get("key"))))
