extends Node

export(PackedScene) var MainMenu

onready var FirstLoadUI = $FirstLoad
onready var Map = $World

var thread = Thread.new()
var loadingbar = ProgressBar.new()

func _ready():
	if "--server" in OS.get_cmdline_args():
		Network.create_server()
		FirstLoadUI.queue_free()
	Data.main_node = self


func _on_Connect_LAN_button_down():
	Network.connect_to_server()
	

func LoadGame():
	$FirstLoad/VBoxContainer.add_child(loadingbar)
	Global.DEBUG_Mode = $FirstLoad/VBoxContainer/Check_Debug.pressed
	Global.EnableFOV = $FirstLoad/VBoxContainer/Check_fov.pressed
	Global.EnableFPSTracker = $FirstLoad/VBoxContainer/Check_tracker.pressed
	loadingbar.value += 25
	var menu = MainMenu.instance()
	call_deferred("add_child", menu)
	Map.visible = true
	FirstLoadUI.queue_free()
	

