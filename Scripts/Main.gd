extends Node

#Always-Avaliable stuff
@onready var FirstLoadUI = $MainUI/FirstLoad
@onready var UI_Chat = $MainUI/Chat
@onready var Map = $LevelContainer
@onready var MainMenu = $MainUI/MainMenu
@onready var LoginScreen = $MainUI/AccountUI
@onready var PauseScreen = $MainUI/PauseScreen

var key #The player's token for saving and loading him

var CanOpenPauseMenu : bool = false

var net_thread = Thread.new()

func _ready():
	set_physics_process(false)
	CheckForExecutableLaunchArguments()
	var dir : FileAccess
	if(dir.dir_exists("user://saves/") or dir.dir_exists("user://accounts/")):
		pass
	else:
		dir.make_dir("user://saves/")
		dir.make_dir("user://accounts/")
	Data.main_node = self
	if(OS.is_debug_build() or OS.has_feature("editor")):
		$MainUI/FirstLoad/StartupSettings/Check_Debug.button_pressed = true


func CheckForExecutableLaunchArguments():
	if "--server" in OS.get_cmdline_args():
		NetworkManager.Network.create_server()
		FirstLoadUI.visible = false
	if "--singleplayer" in OS.get_cmdline_args():
		NetworkManager.Network.create_server()
		ShowLoginScreen()
	if "--debug" in OS.get_cmdline_args(): #In case we want to access debug mode while --singleplayer is active
		#Global.DEBUG_Mode = true
		$MainUI/FirstLoad/StartupSettings/Check_Debug.button_pressed = true
		

func ShowLoginScreen():
	FirstLoadUI.visible = false
	LoginScreen.visible = true

func LoadGame():
	set_physics_process(true)
	#Global.DEBUG_Mode = $MainUI/FirstLoad/StartupSettings/Check_Debug.pressed
	#Global.EnableFOV = $MainUI/FirstLoad/StartupSettings/Check_fov.pressed
	#Global.EnableFPSTracker = $MainUI/FirstLoad/StartupSettings/Check_tracker.pressed
	#Global.PeacefulMode = $MainUI/FirstLoad/StartupSettings/Check_Peace.pressed
	MainMenu.ShowStartingPage()
	$OpeningEyeCandy.visible = false
	$OpeningEyeCandy.emitting = false
	LoginScreen.visible = false
	FirstLoadUI.visible = false
	UI_Chat.visible = true
	SpellManager.SetMaster()
	#UI_Chat.set_multiplayer_authority(get_tree().get_unique_id())

func _input(event):
	if(Input.is_action_just_pressed("pause") and CanOpenPauseMenu):
		if(PauseScreen.visible):
			PauseScreen.visible = false
		else:
			PauseScreen.visible = true

