extends Node

const DEFAULT_PORT = 31416
const DEFAULT_IP = '127.0.0.1'
const MAX_PLAYERS    = 127


const ping_interval = 1.0           # Wait one second between ping requests
const ping_timeout = 5.0            # Wait 5 seconds before considering a ping request as lost

var players   = {}
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
	
func create_server():
	players[1] = str(get_tree().get_network_unique_id())
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)
	print(str("[Networking]: Server created // Server ID -> " + str(get_tree().get_network_unique_id())))
	set_network_master(1)

func connect_to_server():
	get_tree().connect('connected_to_server', self, '_connected_to_server')
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(DEFAULT_IP, DEFAULT_PORT)
	get_tree().set_network_peer(peer)

func _connected_to_server():
	var local_player_id = get_tree().get_network_unique_id()
	print("[Networking]: Connected to server. Loading game..")
	Data.main_node.LoadGame()
	print("[Networking] - DEBUG - Players: ", players)

func _on_player_disconnected(id):
	if(PlayerContainer.has_node(str(id))): PlayerContainer.get_node(str(id)).queue_free()
	print(str("[Networking]: " + str(id) + " disconnected."))
	players.erase(id)

func _on_player_connected(connected_player_id):
	print("[Networking] - player_connected:", connected_player_id)
	print("[Networking] - PlayerList:", players)
	players[str(connected_player_id)] = connected_player_id
	print("[Networking] - Check players -> ", players)
	var local_player_id = get_tree().get_network_unique_id()
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
			state.erase(get_tree().get_network_unique_id()) #I forgot what this oes but don't remove it unless you want your PC to crash
			for player in state.keys():
				if(PlayerContainer.has_node(str(player))): #Checks if the player exists on the client side
					PlayerContainer.get_node(str(player)).UpdatePlayer(state[player]["P"], state[player]["A"])
					#print("[Networking] - Updating ", player, " data.")
				else: #If the player doesn't exist, create them.
					if(state.size() > PlayerContainer.get_child_count()): #This is to prevent players from getting infintally created
						print(player, " does not exist, creating new copy.")
						NetworkingFunctions.CreateThePlayer(state[player]["N"], 1, 1, null, state[player]["P"], player) #Reminder that this needs to be updated to actually sync more accurate player data instead of spawning the wrong house and info.
				
	#print(world_state)
		
func _physics_process(delta):
	if not world_data.empty():
		world_state = world_data.duplicate(true)
		for player in world_state.keys():
			world_state[player].erase("T")
		world_state["T"] = OS.get_system_time_msecs()
		SendWorldState(world_state)
