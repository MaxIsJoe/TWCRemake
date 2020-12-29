extends Node

export(PackedScene) var MapFile
export(PackedScene) var MainMenu
export(bool) var JoinOfficalServer = true

onready var FirstLoadUI = $FirstLoad

func _ready():
	if "--server" in OS.get_cmdline_args():
		Network.create_server()
	Data.main_node = self


func _on_Connect_LAN_button_down():
	#if $FirstLoad/VBoxContainer/HBoxContainer2/ID_Text.text == "":
	#	return
	#Network.connect_to_server($FirstLoad/VBoxContainer/HBoxContainer2/ID_Text.text)
	Network.connect_to_server()
	

func LoadGame():
	var loadingbar = ProgressBar.new()
	$FirstLoad/VBoxContainer.add_child(loadingbar)
	if($FirstLoad/VBoxContainer/Check_Debug.pressed): Global.DEBUG_Mode = true; else: Global.DEBUG_Mode = false
	if($FirstLoad/VBoxContainer/Check_fov.pressed): Global.EnableFOV = true; else: Global.EnableFOV = false
	if($FirstLoad/VBoxContainer/Check_tracker.pressed): Global.EnableFPSTracker = true; else: Global.EnableFPSTracker = false
	loadingbar.value += 25
	var map = MapFile.instance()
	var menu = MainMenu.instance()
	loadingbar.value += 25
	add_child(map)
	loadingbar.value += 25
	add_child(menu)
	loadingbar.value += 25
	FirstLoadUI.queue_free()


func _on_Host_button_down():
	#if $FirstLoad/VBoxContainer/HBoxContainer2/ID_Text.text == "":
	#	return
	#Network.create_server($FirstLoad/VBoxContainer/HBoxContainer2/ID_Text.text)
	Network.create_server()
	var note = RichTextLabel.new()
	note.bbcode_enabled = true
	note.bbcode_text = "[color=green]You are now hosting locally, online hosting is not implamented yet.[/color]"
	$FirstLoad/VBoxContainer/HBoxContainer/Host.disabled = true
	FirstLoadUI.add_child(note)
	note.rect_size = Vector2(1000,400)
