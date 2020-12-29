extends Node

const DEFAULT_PORT = 31416
const DEFAULT_IP = '127.0.0.1'
const MAX_PLAYERS    = 127


const ping_interval = 1.0           # Wait one second between ping requests
const ping_timeout = 5.0            # Wait 5 seconds before considering a ping request as lost

var self_data = {}

var world_data = {}
var world_state = {}

var PlayerContainer

var last_world_state = 0

signal player_disconnected
signal server_disconnected

func _ready():
	get_tree().connect('network_peer_disconnected', self, '_on_player_disconnected')
	get_tree().connect('network_peer_connected', self, '_on_player_connected')
	var player_container = Node.new()
	player_container.name = "Container"
	add_child(player_container)
	PlayerContainer = get_node("Container")
	world_state["T"] = OS.get_system_time_msecs()
	
func create_server():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)
	set_network_master(1)
	print(str("[Networking]: Server created // Server ID -> " + str(get_tree().get_network_unique_id())))
	world_state["T"] = OS.get_system_time_msecs()

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
	Data.main_node.LoadGame()

func _on_player_disconnected(id):
	print(str("[Networking]: " + str(id) + " disconnected."))
	if(id != 0 or id != 1):
		Data.Chat.Send_System_Text(str(world_state[id]["N"]) + " logged off.")
	world_state.erase(id)
	if(PlayerContainer.has_node(str(id))): PlayerContainer.get_node(str(id)).queue_free()

func _on_player_connected(connected_player_id):
	print("[Networking] - player_connected:", connected_player_id)
	var PlayerState
	if(connected_player_id == 1):
		PlayerState = {"T": OS.get_system_time_msecs(),"IMM": true, "P":Vector2(0,0), "A": "idleup", "H": 2, "N": "server", "G": 1}
		print("Creating server character to avoid crashes.")
	else:
		PlayerState = {"T": OS.get_system_time_msecs(),"IMM": true}
	#world_state[connected_player_id] = PlayerState
	SendData(PlayerState)
	print("\n[Networking] - Check Wolrd_State ->", world_state)
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
	
remote func GetWorldState(state):
	if(!state.empty()):
		if state["T"] > last_world_state:
			last_world_state = state["T"]
			state.erase("T")
			state.erase(get_tree().get_network_unique_id()) #This removes the client from the list so we can focus on the other players
			for player in state.keys():
				if(player != 0):
					if(PlayerContainer.has_node(str(player))): #Checks if the player exists on the client side
						PlayerContainer.get_node(str(player)).UpdatePlayer(state[player]["P"], state[player]["A"])
					else: #If the player doesn't exist, create them.
						if(state.size() > PlayerContainer.get_child_count()): #This is to prevent players from getting infintally created
							NetworkingFunctions.rpc("CreateThePlayer", state[player]["N"], state[player]["H"], state[player]["G"], null, state[player]["P"], player)
				###NOTE TO SELF(MAX): don't print anything, just don't. fixing this is already enough to make me lose my sanity, lag and crashing is the last thing I need while I fix this.###
		
func _physics_process(delta):
	if not world_data.empty():
		world_state = world_data.duplicate(true)
		for player in world_state.keys():
			world_state[player].erase("T")
		world_state["T"] = OS.get_system_time_msecs()
		SendWorldState(world_state)
