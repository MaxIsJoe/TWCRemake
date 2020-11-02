extends Node

const DEFAULT_PORT = 31416
const DEFAULT_IP = '127.0.0.1'
const MAX_PLAYERS    = 127


const ping_interval = 1.0           # Wait one second between ping requests
const ping_timeout = 5.0            # Wait 5 seconds before considering a ping request as lost

var players   = {}
var self_data = { name = '', position = Vector2(360, 180) }

# This dictionary holds an entry for each connected player and will keep the necessary data to perform
# ping/pong requests. This will be filled only on the server
var ping_data = {}

signal player_disconnected
signal server_disconnected

func _ready():
	get_tree().connect("network_peer_connected", self, "_on_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_player_disconnected")
	get_tree().connect("connected_to_server", self, "_on_connected_to_server")
	get_tree().connect("connection_failed", self, "_on_connection_failed")
	get_tree().connect("server_disconnected", self, "_on_disconnected_from_server")

func CreateServer(PlayerName):
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, MAX_PLAYERS)
	get_tree().network_peer = peer
	
func ConnectToServer(PlayerName):
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(DEFAULT_IP, DEFAULT_PORT)
	get_tree().network_peer = peer
	
remote func register_player(info):
	# Get the id of the RPC sender.
	var id = get_tree().get_rpc_sender_id()
	# Store the info
	players[id] = info

# Everyone gets notified whenever a new client joins the server
func _on_player_connected(id):
	pass


# Everyone gets notified whenever someone disconnects from the server
func _on_player_disconnected(id):
	pass


# Peer trying to connect to server is notified on success
func _on_connected_to_server():
	pass


# Peer trying to connect to server is notified on failure
func _on_connection_failed():
	pass


# Peer is notified when disconnected from server
func _on_disconnected_from_server():
	pass
