extends KinematicBody2D

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
export (String) var PlayerName
export (String) var PlayerRank
export (String) var PlayerYear
export (String) var PlayerHouse
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
onready var LevelUpAnim = $UI/Leveup/LevelUpAnim
onready var PlayerNameUI = $PlayerName
onready var tabs = $UI/TabContainer

var gender
#var velocity = Vector2()
var alive = true
var canmove = true
var Karma = 100
var statpoints = 0
var spellppoints = 0
var currentscene
#Inventory
var ItemsArray = []

signal isdead
signal GrabbedAnItem(item)
signal hpupdate(health)
signal mpupdate(mana)

const SPEED = 150

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
	#Check their gender
	if(IsMale == true):
		gender = "Male"
	if(IsFemale == true):
		gender = "Female"
	emit_signal("hpupdate", health)
	emit_signal("mpupdate", mana)
	print(currentscene)

	
	
func _physics_process(delta):
	if canmove == false: #Can the player move?
		return
	var rot_dir = 0
	var velocity = Vector2()
	if(Input.is_action_pressed("ui_up")):
		velocity.y -= 1
		animstate.play("walkup")
	if(Input.is_action_pressed("ui_down")):
		velocity.y += 1
		animstate.play("walkdown")
	if(Input.is_action_pressed("ui_right")):
		velocity.x += 1
		animstate.play("walkright")
	if(Input.is_action_pressed("ui_left")):
		velocity.x -= 1
		animstate.play("walkleft")
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
			
func updatenamelabel():
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

func SetPosition(Position):
	self.position = Position
	
func grab(item):
	ItemsArray.append(item)
	emit_signal("GrabbedAnItem", item)