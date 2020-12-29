extends KinematicBody2D

export (String) var PlayerName
export (String) var PlayerRank #Ranks are earned via completing quests, earing achivements or becoming a teacher/moderator/admin
export (int) var PlayerYear = 1 #What year is the player in? This is tied to player and content progression and leveling up
export (int) var health
export (int) var maxHealth
export (int) var mana
export (int) var maxMana
export (int) var damage #The player's base damage
export (int) var defense #The player's base defense
export (int) var gold #How much money does the player have?
export (int) var EXP #How much XP points does he have currently?
export (int) var MaxEXP #How much XP is required before he can level up?
export (int) var level #Player level
#export (float) var speed
export (bool) var CanDrawWand #Used for spell checks, dueling and more
#A bunch of variables that define's the player, this should be updated later to something more.. cleaner.. but this will do for now.
export (int, "Male", "Female") var Gender
export (int, "Gryffindor", "Hufflepuff", "Ravenclaw", "Slytherin") var House

onready var animstate = get_node("AnimatedSprite")
#onready var InventoryUI = get_node("Inventory/InventoryUI")
onready var LevelUpAnim = $Cam/CanvasLayer/UI/Leveup/LevelUpAnim
onready var PlayerNameUI = $PlayerName
onready var tabs = $Cam/CanvasLayer/UI/TabContainer
onready var ScrollUI = $Cam/CanvasLayer/UI/Scroll
onready var PopUpUI = $Cam/CanvasLayer/UI/WindowDialog
onready var AudioLocal = $Audio/Audio_Pos
onready var Audio = $Audio/Audio
onready var Shootpoint = $SpellManager/ShootPoint
onready var TargertPoint = $SpellManager/TargetPoint

#var velocity = Vector2()
var alive = true #Used for handling how everything around the player behaves
slave var canmove = true #Can the player move?
var Karma = 100 #Used for quests, NPC behavior, clans and applying damage reduction on player's who aren't fighting and have higher karma points.
var statpoints = 0 #Used for upgrading the player's stats
var spellppoints = 0 #Used for learning new spells without having to go to a teacher

enum LookDirections {UP,LEFT,RIGHT,DOWN}
var LookingDirection


var ItemsArray = [] #Will be used for the save system

var PlayerState = {} #For networking


signal isdead
signal GrabbedAnItem(item)
signal hpupdate(health)
signal mpupdate(mana)

const SPEED = 350

func _ready():
	#For now, always make sure that the player HP = MaxHP until we add a save system
	
	health = maxHealth
	mana = maxMana
	emit_signal("hpupdate", health)
	emit_signal("mpupdate", mana)
	
	if(is_network_master()):
		if(get_tree().get_network_unique_id() != 1):
			$Cam.current = true
			$Cam/CanvasLayer/UI.visible = true
			if(Global.EnableFOV):
				$Light2D.shadow_enabled = true
			else:
				$Light2D.shadow_enabled = false
		Data.Player = self
		
	Send_PlayerState()
	
func _physics_process(delta):
	if is_network_master():
		if canmove == false: #Can the player move?
			return
		var rot_dir = 0
		var velocity = Vector2()
		if(Input.is_action_pressed("ui_up")):
			velocity.y -= 1
			animstate.play("walkup")
			UpdateShootingPostion("up")
		if(Input.is_action_pressed("ui_down")):
			velocity.y += 1
			animstate.play("walkdown")
			UpdateShootingPostion("down")
		if(Input.is_action_pressed("ui_right")):
			velocity.x += 1
			animstate.play("walkright")
			UpdateShootingPostion("right")
		if(Input.is_action_pressed("ui_left")):
			velocity.x -= 1
			animstate.play("walkleft")
			UpdateShootingPostion("left")
		if(Input.is_action_just_released("ui_up")):
			animstate.play("idleup")
		if(Input.is_action_just_released("ui_down")):
			animstate.play("idledown")
		if(Input.is_action_just_released("ui_right")):
			animstate.play("idleright")
		if(Input.is_action_just_released("ui_left")):
			animstate.play("idleleft")
		
		velocity = velocity.normalized() * SPEED
		
		if velocity != Vector2():
			move_and_slide(velocity)
		Send_PlayerState()

func Send_PlayerState():
	var IMM = false
	if(get_tree().get_network_unique_id() == 1): IMM = true
	PlayerState = {"T": OS.get_system_time_msecs(),"IMM": IMM, "P": global_position, "A": animstate.animation, "H": House, "N": PlayerName, "G": Gender}
	Network.rpc_unreliable("SendData", PlayerState)
	
func UpdatePlayer(pos, anim):
	global_position = lerp(global_position, pos, 0.5)
	animstate.animation = anim

func _input(event):
	#if(Input.is_action_just_pressed("InventoryButton")):
	#	if InventoryUI.visible == true:   
	#		InventoryUI.visible = false
	#	else:
	#		InventoryUI.visible = true
	if(Input.is_action_just_pressed("OpenTabs")):
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

func takedamage(dmg):
	health -= dmg
	emit_signal("hpupdate", health)
	
func healthregen(amount):
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

master func SetPosition(Position):
	self.position = Position
	
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

func ShootSpell(Spell, Argument):
	if(Argument == "player"):
		Argument = Data.Player
	$SpellManager.ShootSpell(Spell)
	$SpellManager.TargetSpell(Spell, Argument)

func ShowHotkeyAsign(ID):
	$Cam/CanvasLayer/UI/SetHotkeyUI.visible = true
	$Cam/CanvasLayer/UI/SetHotkeyUI.ID = ID
