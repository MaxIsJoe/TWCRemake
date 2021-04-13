extends Node

#Always-Avaliable stuff
onready var FirstLoadUI = $MainUI/FirstLoad
onready var UI_Chat = $MainUI/Chat
onready var Map = $World
onready var MainMenu = $MainUI/MainMenu
onready var LoginScreen = $MainUI/AccountUI
onready var PauseScreen = $MainUI/PauseScreen

var key #The player's token for saving and loading him

var CanOpenPauseMenu : bool = false

func _ready():
	if "--server" in OS.get_cmdline_args():
		NetworkManager.Network.create_server()
		FirstLoadUI.queue_free()
	var dir = Directory.new()
	if(dir.dir_exists("user://saves/") or dir.dir_exists("user://accounts/")):
		pass
	else:
		dir.make_dir("user://saves/")
		dir.make_dir("user://accounts/")
	Data.main_node = self


func _on_Connect_LAN_button_down():
	NetworkManager.Network.connect_to_server()

func ShowLoginScreen():
	FirstLoadUI.visible = false
	LoginScreen.visible = true
	LoginScreen.set_network_master(1)

func LoadGame():
	Global.DEBUG_Mode = $MainUI/FirstLoad/VBoxContainer/Check_Debug.pressed
	Global.EnableFOV = $MainUI/FirstLoad/VBoxContainer/Check_fov.pressed
	Global.EnableFPSTracker = $MainUI/FirstLoad/VBoxContainer/Check_tracker.pressed
	MainMenu.ShowStartingPage()
	Map.visible = true
	LoginScreen.queue_free()
	FirstLoadUI.queue_free()
	UI_Chat.visible = true
	SpellManager.SetMaster()
	#UI_Chat.set_network_master(get_tree().get_network_unique_id())

func _input(event):
	if(Input.is_action_just_pressed("ui_home")):
		if(self.has_node("MainUI/FirstLoad")): #Mainly used for debugging the server from the editor.
			NetworkManager.Network.create_server()
			print("Created LAN server.")
			FirstLoadUI.queue_free()
	if(Input.is_action_just_pressed("pause") and CanOpenPauseMenu):
		if(PauseScreen.visible):
			PauseScreen.visible = false
		else:
			PauseScreen.visible = true
