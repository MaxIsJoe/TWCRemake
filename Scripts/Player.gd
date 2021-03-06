extends KinematicBody2D

var PlayerName : String
var PlayerTitle: String      #Ranks are earned via completing quests, earing achivements or becoming a teacher/moderator/admin
var PlayerYear : int   = 1   #What year is the player in? This is tied to player and content progression and leveling up
var health     : int   = 100
var maxHealth  : int   = 100
var mana       : int   = 100
var maxMana    : int   = 100
var damage     : int   = 25  #The player's base damage
var defense    : int   = 0   #The player's base defense
var gold       : int   = 100 #How much money does the player have?
var EXP        : int   = 0   #How much XP points does he have currently?
var MaxEXP     : int   = 200 #How much XP is required before he can level up?
var level      : int   = 1#Player level
var CanDrawWand: bool  = true #Used for spell checks, dueling and more
export (int, "Male", "Female") var Gender
export (int, "Gryffindor", "Hufflepuff", "Ravenclaw", "Slytherin") var House

onready var SpriteHandler = $SpritesHandler
onready var LevelUpAnim = $Cam/CanvasLayer/UI/Leveup/LevelUpAnim
onready var PlayerNameUI = $PlayerName
onready var tabs = $Cam/CanvasLayer/UI/TabContainer
onready var ScrollUI = $Cam/CanvasLayer/UI/Scroll
onready var PopUpUI = $Cam/CanvasLayer/UI/WindowDialog
onready var AudioLocal = $Audio/Audio_Pos
onready var Audio = $Audio/Audio
onready var Shootpoint = $Spell_Pointers/ShootPoint
onready var TargertPoint = $Spell_Pointers/TargetPoint

#var velocity = Vector2()
var alive = true #Used for handling how everything around the player behaves
puppet var canmove = true #Can the player move?
var Karma = 100 #Used for quests, NPC behavior, clans and applying damage reduction on player's who aren't fighting and have higher karma points.
var statpoints = 0 #Used for upgrading the player's stats
var spellppoints = 0 #Used for learning new spells without having to go to a teacher

enum LookDirections {UP,LEFT,RIGHT,DOWN}
var LookingDirection


var ItemsArray = []

var PlayerState = {} #For networking
var playerkey #For saving and account mangement

signal GrabbedAnItem(item)
signal hpupdate(health)
signal mpupdate(mana)

const SPEED = 350

func _ready():
	playerkey = Data.main_node.key
	
	#For now, always make sure that the player HP = MaxHP until we add a save system
	#this getting deprcyted lol
	health = maxHealth
	mana = maxMana
	emit_signal("hpupdate", health)
	emit_signal("mpupdate", mana)
	
	if(is_network_master()):
		if(get_tree().get_network_unique_id() != 1):
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
	
func SetupBodySprites():
	match Gender:
		0:
			match House:
				0:
					SpriteHandler.LoadAnimatedSprites(Data.Grif_Male, $SpritesHandler/Body)
				1:
					SpriteHandler.LoadAnimatedSprites(Data.Huff_Male, $SpritesHandler/Body)
				2:
					SpriteHandler.LoadAnimatedSprites(Data.Claw_Male, $SpritesHandler/Body)
				3:
					SpriteHandler.LoadAnimatedSprites(Data.Slyth_Male, $SpritesHandler/Body)
		1:
			match House:
				0:
					SpriteHandler.LoadAnimatedSprites(Data.Grif_Female, $SpritesHandler/Body)
				1:
					SpriteHandler.LoadAnimatedSprites(Data.Huff_Female, $SpritesHandler/Body)
				2:
					SpriteHandler.LoadAnimatedSprites(Data.Claw_Female, $SpritesHandler/Body)
				3:
					SpriteHandler.LoadAnimatedSprites(Data.Slyth_Female, $SpritesHandler/Body)
	
func _physics_process(delta):
	if is_network_master():
		if canmove == false: #Can the player move?
			return
		var velocity = Vector2()
		if(Input.is_action_pressed("ui_up")):
			velocity.y -= 1
			SpriteHandler.PlayDirectionalAnimAll(13)
			UpdateShootingPostion("up")
		if(Input.is_action_pressed("ui_down")):
			velocity.y += 1
			SpriteHandler.PlayDirectionalAnimAll(10)
			UpdateShootingPostion("down")
		if(Input.is_action_pressed("ui_right")):
			velocity.x += 1
			SpriteHandler.PlayDirectionalAnimAll(12)
			UpdateShootingPostion("right")
		if(Input.is_action_pressed("ui_left")):
			velocity.x -= 1
			SpriteHandler.PlayDirectionalAnimAll(11)
			UpdateShootingPostion("left")
		if(Input.is_action_just_released("ui_up")):
			SpriteHandler.PlayDirectionalAnimAll(3)
		if(Input.is_action_just_released("ui_down")):
			SpriteHandler.PlayDirectionalAnimAll(0)
		if(Input.is_action_just_released("ui_right")):
			SpriteHandler.PlayDirectionalAnimAll(2)
		if(Input.is_action_just_released("ui_left")):
			SpriteHandler.PlayDirectionalAnimAll(1)
		
		velocity = velocity.normalized() * SPEED
		
		if velocity != Vector2():
			move_and_slide(velocity)
		Send_PlayerState()

func Send_PlayerState():
	PlayerState = {"T": OS.get_system_time_msecs(), "P": global_position, "A": SpriteHandler.currentDir, "LD": LookingDirection, "D": damage, "SP": Shootpoint.global_transform}
	NetworkManager.Network.rpc_unreliable("SendData", PlayerState)
	
func UpdatePlayer(pos, anim, ld, d, SP):
	global_position = lerp(global_position, pos, 0.8)
	SpriteHandler.PlayDirectionalAnimAll(anim)
	LookingDirection = ld
	damage = d
	Shootpoint = SP

func GetSavePlayerInfo():
	var info = {"N": PlayerName, 
	"H": House, 
	"G": Gender, 
	"D": damage, 
	"Year": PlayerYear, 
	"lvl": level, "EXP": EXP, "MEXP": MaxEXP, 
	"gold": gold, 
	"HP": health, "mHP": maxHealth, "MP": mana, "MMP": maxMana,
	"StatPoints": statpoints, "SpellPoints": spellppoints,
	"vx": global_position.x,
	"vy": global_position.y,
	"key": playerkey}
	if(info.get("key") == null): push_warning("\a Warning, Key is null.")
	return info

remote func SendKeyToServer(key):
	playerkey = key

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
			takedamage(5)
		if(Input.is_action_just_pressed("ui_page_up")):
			expgain(50)
			print("Your level is ", level," Your EXP is ",EXP," and your MaxEXP = ",MaxEXP)
		if(Input.is_action_just_pressed("DEBUG_DisableShadows")):
			if($Light2D.shadow_enabled):
				$Light2D.shadow_enabled = false
			else:
				$Light2D.shadow_enabled = true

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

remotesync func takedamage(dmg):
	health -= dmg
	emit_signal("hpupdate", health)
	
remotesync func healthregen(amount):
	health += amount
	emit_signal("hpupdate", health)
	
func manatake(amount):
	mana -= amount
func manaregen(amount):
	mana += amount
	
func expgain(amount):
		EXP += amount
		levelupcheck()

func levelupcheck():
	if(EXP >= MaxEXP):
		level += 1
		MaxEXP *= level / 2 #This is temporary. Change later.
		EXP = 0
		statpoints += 1
		LevelUpAnim.play("FadeInFadeOut")
	
func grab(item):
	ItemsArray.append(item)
	emit_signal("GrabbedAnItem", item)
	
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
