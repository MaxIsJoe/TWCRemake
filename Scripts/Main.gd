extends Node

export(PackedScene) var MapFile
export(PackedScene) var MainMenu
export(bool) var JoinOfficalServer = true

onready var FirstLoadUI = $FirstLoad

var thread = Thread.new()
var loadingbar = ProgressBar.new()

func _ready():
	if "--server" in OS.get_cmdline_args():
		Network.create_server()
		Network.SetPhysicsProcess(true)
	Data.main_node = self


func _on_Connect_LAN_button_down():
	#if $FirstLoad/VBoxContainer/HBoxContainer2/ID_Text.text == "":
	#	return
	#Network.connect_to_server($FirstLoad/VBoxContainer/HBoxContainer2/ID_Text.text)
	Network.connect_to_server()
	

func LoadGame():
	$FirstLoad/VBoxContainer.add_child(loadingbar)
	if($FirstLoad/VBoxContainer/Check_Debug.pressed): Global.DEBUG_Mode = true; else: Global.DEBUG_Mode = false
	if($FirstLoad/VBoxContainer/Check_fov.pressed): Global.EnableFOV = true; else: Global.EnableFOV = false
	if($FirstLoad/VBoxContainer/Check_tracker.pressed): Global.EnableFPSTracker = true; else: Global.EnableFPSTracker = false
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
