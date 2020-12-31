extends Node

export(PackedScene) var MapFile
export(PackedScene) var MainMenu

onready var FirstLoadUI = $FirstLoad

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
	thread.start(self, "LoadMap", null, 1)

func LoadMap(n):
	var map = MapFile.instance()
	var menu = MainMenu.instance()
	loadingbar.value += 25
	call_deferred("add_child", map)
	loadingbar.value += 25
	call_deferred("add_child", menu)
	loadingbar.value += 25
	FirstLoadUI.queue_free()
	Network.SetPhysicsProcess(true)
