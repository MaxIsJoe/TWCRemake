extends KinematicBody2D

export (int) var heatlh
export (int) var maxHealth
export (int) var mana
export (int) var maxMana
export (int) var damage
export (int) var defense
export (int) var gold
export (int) var level
export (int) var levelcap
export (float) var speed
export (String) var PlayerName
export (String) var PlayerRank
export (String) var PlayerYear
export (String) var PlayerHouse
export (bool) var CanDrawWand
export (bool) var MaxedLevel
export (bool) var IsMale
export (bool) var IsFemale
export (bool) var IsGryif
export (bool) var IsSlyth
export (bool) var IsHuff
export (bool) var IsClaw
export (bool) var IsNew

onready var animstate = get_node("AnimatedSprite")
onready var InventoryUI = get_node("Inventory/InventoryUI")

var EXP
var lvlupEXP
var gender
#var velocity = Vector2()
var alive = true
var canmove = true
var Karma = 100

signal isdead
signal hpupdate
signal mpupdate

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
	if(IsNew == true):
		PlayerHouse = "None"
	#Check their gender
	if(IsMale == true):
		gender = "Male"
	if(IsFemale == true):
		gender = "Female"
	

	
	
func _physics_process(delta):
	if canmove == false:
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
	velocity = velocity.normalized() * speed
	move_and_slide(velocity)
	
func _input(event):
	if(Input.is_action_just_pressed("InventoryButton")):
		if InventoryUI.visible == true:
			InventoryUI.visible = false
		else:
			InventoryUI.visible = true