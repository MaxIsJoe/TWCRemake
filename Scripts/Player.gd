extends KinematicBody2D

export (String) var PlayerName
export (String) var PlayerRank
export (String) var PlayerHouse
export (int) var PlayerYear = 1
export (int) var health
export (int) var maxHealth
export (int) var mana
export (int) var maxMana
export (int) var damage
export (int) var defense
export (int) var gold
export (int) var EXP
export (int) var MaxEXP
export (int) var level
export (int) var levelcap
#export (float) var speed
export (bool) var CanDrawWand
export (bool) var IsMale
export (bool) var IsFemale
export (bool) var IsGryif
export (bool) var IsSlyth
export (bool) var IsHuff
export (bool) var IsClaw
export (bool) var IsNew

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

#var velocity = Vector2()
var alive = true
slave var canmove = true
var Karma = 100
var statpoints = 0
var spellppoints = 0
var currentscene

enum LookDirections {UP,LEFT,RIGHT,DOWN}
var LookingDirection

#Inventory
var ItemsArray = []

slave var PlayerPostion = Vector2()

signal isdead
signal GrabbedAnItem(item)
signal hpupdate(health)
signal mpupdate(mana)

const SPEED = 350

func _ready():
	
	#Check what house the player is in at the moment
	if(IsGryif == true):
		PlayerHouse = "Gryffindor"
	if(IsSlyth == true):
		PlayerHouse = "Slytherin"
	if(IsHuff == true):
		PlayerHouse = "Hufflepuff"
	if(IsClaw == true):
		PlayerHouse = "Ravenclaw"
	#if(IsNew == true):
	#	PlayerHouse = "None"
	emit_signal("hpupdate", health)
	emit_signal("mpupdate", mana)
	
	Data.Player = self
	print(currentscene)

	
	
func _physics_process(delta):
	if canmove == false: #Can the player move?
		return
	var rot_dir = 0
	var velocity = Vector2()
	#if (is_network_master()):
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
	move_and_slide(velocity)
	# Check if there is any (meaningful) input
#		if (velocity.x != 0 || velocity.y != 0):
#			# There is some input. If on the server, just update the position
#			if (get_tree().is_network_server()):
#				server_get_player_input(velocity)
#			# Otherwise, request the server to calculate the new position
#			else:
#				rpc_id(1, "server_get_player_input", velocity)
#	# Regardless if this is the master or not, being on the server means: replicate the actor state
#	if (get_tree().is_network_server()):
#		# Replicate the position, using the unreliable protocol
#		rpc_unreliable("client_get_player_update", position)
	
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
	if(Input.is_action_just_pressed("ui_cancel")):
		$SpellManager.ShootSpell("inflamri")

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
	if(IsGryif):
		PlayerNameUI.add_color_override("font_color", Color(0.86,0.08,0.24,1))
	if(IsHuff):
		PlayerNameUI.add_color_override("font_color", Color(1,0.84,0,1))
	if(IsSlyth):
		PlayerNameUI.add_color_override("font_color", Color(0,1,0,1))
	if(IsClaw):
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
	if(level != levelcap):
		EXP += amount
		levelupcheck()
	else:
		return

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
