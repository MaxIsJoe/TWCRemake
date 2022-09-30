extends Node
class_name Network

const DEFAULT_PORT   = 7777
const DEFAULT_IP     = '127.0.0.1'
const MAX_PLAYERS    = 127

var world_data = {}
var world_state = {}
var server_player_dic = {}
var ActiveKeys = {}
var spells_ID = -1

var server_trick_rate = 30

var last_world_state = 0

signal player_disconnected
signal server_disconnected

func _ready():
	#Connect signals
	get_tree().connect('peer_disconnected',Callable(self,'_on_player_disconnected'))
	get_tree().connect('peer_connected',Callable(self,'_on_player_connected'))
	#Create the container that will have the players
	
func create_server():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(DEFAULT_PORT, MAX_PLAYERS)
	get_tree().set_multiplayer_peer(peer)
	set_multiplayer_authority(1)
	print(str("[Networking]: Server created // Server IP -> " + DEFAULT_IP))
	world_state["T"] = Time.get_ticks_msec() #(Max): I don't remember why I needed to set a timestamp this early but the game throws an error randomly if I don't so I'm leaving this here.
	set_physics_process(true)
	Engine.set_physics_ticks_per_second(server_trick_rate) #This is to make the server send calls at a rate that both the server and client and handle
	DayAndNightV2.StartCycle()

func connect_to_server(ip : String):
	get_tree().connect('connected_to_server',Callable(self,'_connected_to_server'))
	var peer = ENetMultiplayerPeer.new()
	if(ip == ""):
		peer.create_client(DEFAULT_IP, DEFAULT_PORT)
	else:
		peer.create_client(ip, DEFAULT_PORT)
	get_tree().set_multiplayer_peer(peer)
	world_state["T"] = Time.get_ticks_msec()

func _connected_to_server():
	var local_player_id = get_tree().get_unique_id()
	print_debug("[Networking]: Connected to server as", local_player_id ,". Loading game..")
	world_state["T"] = Time.get_ticks_msec()
	Data.main_node.ShowLoginScreen()
	DayAndNightV2.SyncTime(local_player_id)

func _on_player_disconnected(id):
	print(str("[Networking]: " + str(id) + " disconnected."))
	Data.main_node.UI_Chat.SendText(0, str(world_data[id]) + " logged unchecked.", "")
	Data.main_node.PauseScreen.BuildPlayerWhoList()
	RemovePlayerID(id)
	world_state.erase(id)
	world_data.erase(id)
	NetworkManager.Functions.rpc("RemovePlayerFromWorld", id) #Remove the player id from all clients and server
	if(Global.DEBUG_Mode):
		print("\n[Networking] - World3D State ->", world_state) #Server side debugging
		print("\n[Networking] - World3D State Size ->", str(world_state.size())) #Server side debugging
	
func _on_player_connected(connected_player_id):
	print("[Networking] - player_connected:", connected_player_id)
	if(Global.DEBUG_Mode):
		print("\n[Networking] - Check Wolrd_State ->", world_state)
		print("\n[Networking] - World3D State Size ->", str(world_state.size())) #Server side debugging

@rpc(any_peer, call_local) func SendData(state):
	var playerID = get_tree().get_remote_sender_id()
	if(world_data.has(playerID)):
		if(world_data[playerID]["T"] < state["T"]):
			world_data[playerID] = state
	else:
		world_data[playerID] = state

func SendWorldState(state):
	if(is_multiplayer_authority()):
		rpc_id(0, "GetWorldState", state)
	
@rpc(any_peer, call_local) func GetWorldState(state):
	###NOTE: Do NOT print anything here for any reason.###
	###If you do,then remove_at it before pushing a change###
	if(!state.is_empty()):
		if(state["map"] != Data.main_node.Map.name): return
		if state["T"] > last_world_state:
			last_world_state = state["T"]
			state.erase("T")
			#state.erase(1) #This prevents the server from creating an empty player
			state.erase(get_tree().get_unique_id()) #This removes the client from the list so we can focus checked the other players
			for player in state.keys():
				Data.main_node.Map.get_node(str(player)).UpdatePlayer(state[player]["P"], state[player]["A"], state[player]["LD"], state[player]["D"], state[player]["SP"])

@rpc(any_peer) func CreateActivePlayers(id): #Creates all players checked the server checked the client
	for player in Data.main_node.Map.players.get_children():
		if(str(player.name) == str(id)): return
		var data : Dictionary = player.GetSavePlayerInfo()
		#Tell the client to create this player with their correct data
		NetworkManager.Functions.rpc_id(id, "CreateThePlayer", data["N"], int(data["G"]), int(data["H"]), null, Vector2(int(data["vx"]), int(data["vy"])), int(player.name))
		
@rpc(any_peer) func GetSavedPlayerData(key, id): #Sends the player's savefile to him, the savefile *should* only exist checked the server.
	var file = FileAccess.open(str("user://saves/" + key + ".json"), FileAccess.READ)
	if(file == OK):
		var dfile = file.get_as_text()
		var test_json_conv = JSON.new()
		test_json_conv.parse(dfile)
		var data = test_json_conv.get_data()
		if(id != 1): 
			Data.main_node.MainMenu.rset_id(id, "saveddata", data)
		else:
			Data.main_node.MainMenu.saveddata = data

@rpc(any_peer) func SetSpellState():
	spells_ID += 1
	rpc_id(0, "SetSpellIDOnAll", spells_ID)
	
@rpc(any_peer) func SetSpellIDOnAll(newID):
	spells_ID = newID
	
@rpc(any_peer) func SendSpellState():
	rpc("SetSpellState")

func RemovePlayerID(id): #Responisble for erasing the player key and making sure it's no longer in world_state
	SavePlayer(id)
	RemoveActiveKey(server_player_dic[id].playerkey)
	if(world_state.has(id)): world_state.erase(id)
	
@rpc(any_peer, call_local) func GetActiveKeys(): #Tell all clients what clients are online and playing right now.
	rpc_id(0, "SetActiveKeys", ActiveKeys)
	
@rpc(any_peer) func SetActiveKeys(Active):
	ActiveKeys = Active

@rpc(any_peer) func AddActiveKey(key): #Add player who's actively playing right now
	var online_id = get_tree().get_remote_sender_id()
	ActiveKeys[key] = {"ID": online_id}
	GetActiveKeys()
	
func RemoveActiveKey(key): #Remove a key that belongs to a player who is no longer connected.
	ActiveKeys.erase(key)
	GetActiveKeys()

func _physics_process(delta):
	if not world_data.is_empty():
		world_state = world_data.duplicate(true)
		for player in world_state.keys():
			world_state[player].erase("T")
		world_state["T"] = Time.get_ticks_msec()
		SendWorldState(world_state)

func SavePlayer(id):
	#var playerdata = PlayerContainer.get_node(str(id)).GetSavePlayerInfo()
	#JsonLoader.SaveJSON(playerdata, str("user://saves/" + str(playerdata.get("key")) + ".json"))
	#print_debug(str("Hey shitass, I'm saving " + playerdata["N"] + " under key -> " + str(playerdata.get("key"))))
	pass
