extends "res://Scenes/Instances/EntitesBase/Characters/CharacterEntity.gd"

var Gender     : int
var House      : int
var PlayerName : String = "Cuban Pete"
var PlayerYear : int = 1
var gold       : int

var CanDrawWand: bool  = true #Used dueling
var WandDrawn  : bool  = false #Used to check if they can cast a spell or not

enum LookDirections {UP,LEFT,RIGHT,DOWN}
var LookingDirection

var ItemsArray = []

var PlayerState = {} #For networking
var playerkey #For saving and account mangement

onready var LevelUpAnim = $Cam/CanvasLayer/UI/Leveup/LevelUpAnim
onready var PlayerNameUI = $PlayerName
onready var tabs = $Cam/CanvasLayer/UI/TabContainer
onready var ScrollUI = $Cam/CanvasLayer/UI/Scroll
onready var PopUpUI = $Cam/CanvasLayer/UI/WindowDialog
onready var AudioLocal = $Audio/Audio_Pos
onready var Audio = $Audio/Audio
onready var Shootpoint = $Spell_Pointers/ShootPoint
onready var TargertPoint = $Spell_Pointers/TargetPoint

func _ready():
	playerkey = Data.main_node.key
	
	if(get_tree().get_network_unique_id() == 1):
		#This fixes the issue where players jitter during single player
		#LAN games should be much smoother as well because the server is sending data every 60 physics frames
		Engine.set_iterations_per_second(60)
	
	if(is_network_master()):
		$Cam.current = true
		$Cam/CanvasLayer/UI.visible = true
		Data.Player = self
		if(Global.EnableFOV):
			$Light2D.shadow_enabled = true
		else:
			$Light2D.shadow_enabled = false
		if(get_tree().get_network_unique_id() != 1):
			rpc_id(1, "SendKeyToServer", playerkey)
		else:
			SendKeyToServer(playerkey)
		NetworkManager.Network.rpc("AddActiveKey", playerkey)
	
	Send_PlayerState()
	
func SetupPlayer(house: int, Name: String, gender: int):
	PlayerName = Name
	Gender = gender
	House = house
	
	SetupBodySprites()
	updatenamelabel()
	
func Send_PlayerState():
	PlayerState = {"T": OS.get_system_time_msecs(), "P": global_position, "A": SpriteHandler.currentDir, "LD": LookingDirection, "D": stats.damage, "SP": Shootpoint.global_transform}
	NetworkManager.Network.rpc_unreliable("SendData", PlayerState)
	
func UpdatePlayer(pos, anim, ld, d, SP):
	global_position = lerp(global_position, pos, 0.8)
	SpriteHandler.PlayDirectionalAnimAll(anim)
	LookingDirection = ld
	stats.damage = d
	Shootpoint = SP

func GetSavePlayerInfo():
	var info = {"N": PlayerName, 
	"H": House, 
	"G": Gender, 
	"D": stats.damage, 
	"Year": PlayerYear, 
	"lvl": stats.level, "EXP": stats.XP, "MEXP": stats.XP_MAX, 
	"gold": gold, 
	"HP": health.HP, "mHP": health.HP_MAX, "MP": stats.mana, "MMP": stats.mana_max,
	"StatPoints": stats.statpoints, "SpellPoints": stats.spellppoints,
	"vx": global_position.x,
	"vy": global_position.y,
	"key": playerkey}
	if(info.get("key") == null): push_warning("\a Warning, Key is null.")
	return info

remote func SendKeyToServer(key):
	playerkey = key

remote func updatenamelabel():
	PlayerNameUI.text = str(PlayerName)
	if(House == 0):
		PlayerNameUI.add_color_override("font_color", Color(0.86,0.08,0.24,1))
	if(House == 1):
		PlayerNameUI.add_color_override("font_color", Color(1,0.84,0,1))
	if(House == 3):
		PlayerNameUI.add_color_override("font_color", Color(0,1,0,1))
	if(House == 2):
		PlayerNameUI.add_color_override("font_color", Color(0,1,1,1))

func _physics_process(delta):
	if is_network_master():
		getDir()
	Send_PlayerState()

func _input(event):
	if(Input.is_action_just_pressed("OpenTabs")):
		if(tabs == null): tabs = get_node("Cam/CanvasLayer/UI/TabContainer") #Use get_node() because holy fuck does Godot never make sense sometimes
		#Always check if tabs exist because for some reason tabs become null for new connections without any reason
		if tabs.visible == true:
			tabs.visible = false
		else:
			tabs.visible = true
	#DEBUG
	if(Global.DEBUG_Mode):
		if(Input.is_action_just_pressed("ui_page_down")):
			health.TakeDamage(5)
		if(Input.is_action_just_pressed("ui_page_up")):
			stats.gainXP(50)
		if(Input.is_action_just_pressed("DEBUG_DisableShadows")):
			if($Light2D.shadow_enabled):
				$Light2D.shadow_enabled = false
			else:
				$Light2D.shadow_enabled = true

func SetupBodySprites():
	match Gender:
		0:
			match House:
				0:
					SpriteHandler.LoadAnimatedSprites(Data.Grif_Male, BodySprites)
				1:
					SpriteHandler.LoadAnimatedSprites(Data.Huff_Male, BodySprites)
				2:
					SpriteHandler.LoadAnimatedSprites(Data.Claw_Male, BodySprites)
				3:
					SpriteHandler.LoadAnimatedSprites(Data.Slyth_Male, BodySprites)
		1:
			match House:
				0:
					SpriteHandler.LoadAnimatedSprites(Data.Grif_Female, BodySprites)
				1:
					SpriteHandler.LoadAnimatedSprites(Data.Huff_Female, BodySprites)
				2:
					SpriteHandler.LoadAnimatedSprites(Data.Claw_Female, BodySprites)
				3:
					SpriteHandler.LoadAnimatedSprites(Data.Slyth_Female, BodySprites)


func getDir():
	moveDir.x = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	moveDir.y = -int(Input.is_action_pressed("move_up")) + int(Input.is_action_pressed("move_down"))
	if(moveDir.x == -1):
		UpdateShootingPostion("left")
	if(moveDir.x == 1):
		UpdateShootingPostion("right")
	if(moveDir.y == -1):
		UpdateShootingPostion("up")
	if(moveDir.y == 1):
		UpdateShootingPostion("down")
		
func UpdateShootingPostion(pos):
	match pos:
		"up":
			Shootpoint.position = Vector2(0, -31.702)
			LookingDirection = LookDirections.UP
		"down":
			Shootpoint.position = Vector2(0, 31.702)
			LookingDirection = LookDirections.DOWN
		"left":
			Shootpoint.position = Vector2(-25, 0)
			LookingDirection = LookDirections.LEFT
		"right":
			Shootpoint.position = Vector2(25, 0)
			LookingDirection = LookDirections.RIGHT
	
	
func AddSpellForHotkey(hotkey, action, ActionArguments, ActionCooldown,icon):
	var Hotkeys = get_tree().get_nodes_in_group("UI_HotkeyButton")
	for key in Hotkeys:
		if(key.ButtonHotkey == hotkey):
			key.AddAction(action, ActionArguments, ActionCooldown, icon)

func ShowShopUI(Items, ShopID):
	$Cam/CanvasLayer/UI/ShopUI.OpenShop(Items, ShopID)

func ShowScroll(ID):
	var file = File.new()
	if file.file_exists("res://debug/Scrolls/" + str(ID) + ".txt"):
		var error = file.open("res://debug/Scrolls/" + str(ID) + ".txt", file.READ_WRITE)
		if error == OK:
			print("Showing file [" + str(ID) + "]")
			var content = file.get_as_text()
			ScrollUI.LoadText(content, ID)
			ScrollUI.visible = true
		else:
			print("Error opening the file")
		file.close()
	else:
		print("No scroll files found.. creating a new one")
		file.open("res://debug/Scrolls/" + str(ID) + ".txt", File.WRITE)
		file.store_string("")
		file.close()

func ShowSign(Title, Content):
	PopUpUI.window_title = Title
	PopUpUI.dialog_text = Content
	PopUpUI.popup_centered()

remote func ShootSpell(Spell, Argument):
	if(Argument == "player"):
		Argument = Data.Player
	SpellManager.rpc_id(0, "ShootSpell" ,Spell, get_tree().get_network_unique_id())
	SpellManager.rpc_id(0, "TargetSpell", Spell, Argument)

func ShowHotkeyAsign(ID):
	$Cam/CanvasLayer/UI/SetHotkeyUI.visible = true
	$Cam/CanvasLayer/UI/SetHotkeyUI.ID = ID
