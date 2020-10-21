extends Node

const DEFAULT_PORT = 31416
const DEFAULT_IP = '127.0.0.1'
const MAX_PLAYERS    = 10

const ping_interval = 1.0           # Wait one second between ping requests
const ping_timeout = 5.0            # Wait 5 seconds before considering a ping request as lost

var players   = {}
var self_data = { name = '', position = Vector2(360, 180) }

# This dictionary holds an entry for each connected player and will keep the necessary data to perform
# ping/pong requests. This will be filled only on the server
var ping_data = {}

signal player_disconnected
signal server_disconnected
