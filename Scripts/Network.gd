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
	
func create_server(player_nickname):
	self_data.name = player_nickname
	players[1] = self_data
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)
	print("created server")
	set_network_master(1)

func connect_to_server(player_nickname):
	self_data.name = player_nickname
	get_tree().connect('connected_to_server', self, '_connected_to_server')
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(DEFAULT_IP, DEFAULT_PORT)
	get_tree().set_network_peer(peer)

func _connected_to_server():
	var local_player_id = get_tree().get_network_unique_id()
	players[local_player_id] = self_data
	rpc('_send_player_info', local_player_id, self_data)
	print("connected to server")
	Data.main_node.LoadGame()

func _on_player_disconnected(id):
	players.erase(id)

func _on_player_connected(connected_player_id):
	var local_player_id = get_tree().get_network_unique_id()
	if not(get_tree().is_network_server()):
		rpc_id(1, '_request_player_info', local_player_id, connected_player_id)

remote func _request_player_info(request_from_id, player_id):
	if get_tree().is_network_server():
		rpc_id(request_from_id, '_send_player_info', player_id, players[player_id])

# A function to be used if needed. The purpose is to request all players in the current session.
remote func _request_players(request_from_id):
	if get_tree().is_network_server():
		for peer_id in players:
			if( peer_id != request_from_id):
				rpc_id(request_from_id, '_send_player_info', peer_id, players[peer_id])
				
func SendData(state):
	var playerID = get_tree().get_rpc_sender_id()
	if(world_data.has(playerID)):
		if(world_data[playerID]["T"] < state["T"]):
			world_data[playerID] = state
	else:
		world_data[playerID] = state

func SendWorldState(state):
	rpc_unreliable_id(0, "GetWorldState", state)
	
remote func GetWorldState(state):
	if state["T"] > last_world_state:
		last_world_state = state["T"]
		state.erase("T")
		state.erase(get_tree().get_network_unique_id())
		for player in state.keys():
			if(PlayerContainer.has_node(str(player))):
				PlayerContainer.get_node(str(player)).UpdatePlayer(state[player]["P"])
			else:
				NetworkingFunctions.CreateThePlayer("Testing", 1, state[player]["H"], null, state[player]["P"])
		
func _physics_process(delta):
	if not world_data.empty():
		world_state = world_data.duplicate(true)
		for player in world_state.keys():
			world_state[player].erase("T")
		world_state["T"] = OS.get_system_time_msecs()
		SendWorldState(world_state)
