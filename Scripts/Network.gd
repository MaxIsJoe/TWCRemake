extends Node

const DEFAULT_PORT = 31416
const DEFAULT_IP = '127.0.0.1'
const MAX_PLAYERS    = 10

const ping_interval = 1.0           # Wait one second between ping requests
const ping_timeout = 5.0            # Wait 5 seconds before considering a ping request as lost

var   players      = {}
var self_data = { name = '', position = Vector2(360, 180) }

# This dictionary holds an entry for each connected player and will keep the necessary data to perform
# ping/pong requests. This will be filled only on the server
var ping_data = {}

signal player_disconnected
signal server_disconnected

signal chat_message_received(msg)
signal ping_updated(peer, value)

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnect")
	
func _player_disconnected(id):
	print("Player ", players[id].name, " disconnected from server")
	get_node(str(id)).queue_free()
	if (get_tree().is_network_server()):
		# Make sure the timer is stoped
		ping_data[id].timer.stop()
		# Remove the timer from the tree
		ping_data[id].timer.queue_free()
		# And from the ping_data dictionary
		ping_data.erase(id)

func _on_server_disconnected():
	pass

func create_server(player_nickname):
	self_data.name = player_nickname
	players[1] = self_data
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)

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
	print("Connected to server")

func _on_player_disconnected(id):
	players.erase(id)

func _on_player_connected(connected_player_id):
	var local_player_id = get_tree().get_network_unique_id()
	if not(get_tree().is_network_server()):
		rpc_id(1, '_request_players', local_player_id, connected_player_id)
	if (get_tree().is_network_server()):
		# Initialize the ping data entry
		var ping_entry = {
			timer = Timer.new(),          # Timer object to control the ping/pong loop
			signature = 0,                # Used to match ping/pong packets
			packet_lost = 0,              # Count number of lost packets
			last_ping = 0,                # Last measured time taken to get an answer from the peer
		}
		
		# Setup the timer
		ping_entry.timer.one_shot = true
		ping_entry.timer.wait_time = ping_interval
		ping_entry.timer.process_mode = Timer.TIMER_PROCESS_IDLE
		ping_entry.timer.connect("timeout", self, "_on_ping_interval", [connected_player_id], CONNECT_ONESHOT)
		ping_entry.timer.set_name("ping_timer_" + str(connected_player_id))
		
		# Timers need to be part of the tree otherwise they are not updated and never fire up the timeout event
		add_child(ping_entry.timer)
		# Add the entry to the dictionary
		ping_data[connected_player_id] = ping_entry
		# Just to ensure, start the timer (in theory it should run but...)
		ping_entry.timer.start()

remote func _request_player_info(request_from_id, player_id):
	if get_tree().is_network_server():
		rpc_id(request_from_id, '_send_player_info', player_id, players[player_id])

# A function to be used if needed. The purpose is to request all players in the current session.
remote func _request_players(request_from_id):
	if get_tree().is_network_server():
		for peer_id in players:
			if( peer_id != request_from_id):
				rpc_id(request_from_id, '_send_player_info', peer_id, players[peer_id])

remote func _send_player_info(id, info):
	players[id] = info

func update_position(id, position):
	players[id].position = position

func get_player_id(player_name):
	for id in players:
		if (players[id].name == player_name):
			return id
	
	# If here the player has not been found. Return an invalid ID
	return 0

func request_ping(dest_id):
	# Configure the timer
	ping_data[dest_id].timer.connect("timeout", self, "_on_ping_timeout", [dest_id], CONNECT_ONESHOT)
	# Start the timer
	ping_data[dest_id].timer.start(ping_timeout)
	# Call the remote machine
	rpc_unreliable_id(dest_id, "on_ping", ping_data[dest_id].signature, ping_data[dest_id].last_ping)
	
remote func on_pong(signature):
	# Bail if not the server
	if (!get_tree().is_network_server()):
		return
	# Obtain the unique ID of the caller
	var peer_id = get_tree().get_rpc_sender_id()
	# Check if the answer matches the expected one
	if (ping_data[peer_id].signature == signature):
		# It does. Calculate the elapsed time, in milliseconds
		ping_data[peer_id].last_ping = (ping_timeout - ping_data[peer_id].timer.time_left) * 1000
		# If here, the ping timeout timer is running but must be configured now for the ping interval
		ping_data[peer_id].timer.stop()
		ping_data[peer_id].timer.disconnect("timeout", self, "_on_ping_timeout")
		ping_data[peer_id].timer.connect("timeout", self, "_on_ping_interval", [peer_id], CONNECT_ONESHOT)
		ping_data[peer_id].timer.start(ping_interval)
		# Broadcast the new value to everyone
		rpc_unreliable("ping_value_changed", peer_id, ping_data[peer_id].last_ping)
		# And allow the server to do something with this value
		emit_signal("ping_updated", peer_id, ping_data[peer_id].last_ping)

remote func on_ping(signature, last_ping):
	# Call the server back
	rpc_unreliable_id(1, "on_pong", signature)
	# Tell this client that there is a new measured ping value - yes, this corresponds to the last request
	emit_signal("ping_updated", get_tree().get_network_unique_id(), last_ping)

func _on_ping_timeout(peer_id):
	print("Ping timeout, destination peer ", peer_id)
	# The last ping request has timedout. No answer received, so assume the packet has been lost
	ping_data[peer_id].packet_lost += 1
	# Update the ping signature that will be sent in the next request
	ping_data[peer_id].signature += 1
	# And request a new ping - we need to wait until the end of the update so that the existing connection gets removed
	call_deferred(request_ping(peer_id))

remote func send_message(src_id, msg):
	var final_msg = "[" + players[src_id].name + "]: " + msg
	emit_signal("chat_message_received", final_msg)
