extends Node

export(PackedScene) var MainMenu

onready var FirstLoadUI = $MainUI/FirstLoad
onready var UI_Chat = $MainUI/Chat
onready var Map = $World

func _ready():
	if "--server" in OS.get_cmdline_args():
		Network.create_server()
		FirstLoadUI.queue_free()
	Data.main_node = self


func _on_Connect_LAN_button_down():
	Network.connect_to_server()

func LoadGame():
	Global.DEBUG_Mode = $MainUI/FirstLoad/VBoxContainer/Check_Debug.pressed
	Global.EnableFOV = $MainUI/FirstLoad/VBoxContainer/Check_fov.pressed
	Global.EnableFPSTracker = $MainUI/FirstLoad/VBoxContainer/Check_tracker.pressed
	var menu = MainMenu.instance()
	call_deferred("add_child", menu)
	Map.visible = true
	UI_Chat.visible = true
	FirstLoadUI.queue_free()
	SpellManager.SetMaster()
	UI_Chat.set_network_master(get_tree().get_network_connected_peers())

