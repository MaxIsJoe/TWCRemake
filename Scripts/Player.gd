extends KinematicBody2D

export (int) var heatlh
export (int) var maxHealth
export (int) var mana
export (int) var maxMana
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
export (Array) var house = ["Gryffindor","Slyth","Huff","Claw"]

onready var animstate = get_node("AnimatedSprite")

var EXP
var lvlupEXP
var gender = ["Male","Female"]
var velocity = Vector2()
var alive = true
var canmove = true
var Karma = 100

signal isdead
signal hpupdate
signal mpupdate

func _ready():
	#Check what house the player is in at the moment
	if(house == "Gryffindor"):
		PlayerHouse = "Gryffindor"
	if(house == "Slyth"):
		PlayerHouse = "Slytherin"
	if(house == "Huff"):
		PlayerHouse = "Hufflepuff"
	if(house == "Claw"):
		PlayerHouse = "Ravenclaw"
	if(house == null):
		PlayerHouse = "None"
	#Check their gender
	if(gender == "Male"):
		IsMale = true
	if(gender == "Female"):
		IsFemale = true
	
	

func move(delta):
	var rot_dir = 0
	var velocity = Vector2()
	if(Input.is_action_pressed("ui_up")):
		velocity = Vector2(speed,0)
		animstate.play("walkup")
	if(Input.is_action_pressed("ui_down")):
		velocity = Vector2(-speed,0)
		animstate.play("walkdown")
	if(Input.is_action_pressed("ui_right")):
		velocity = Vector2(0,speed)
		animstate.play("walkright")
	if(Input.is_action_pressed("ui_left")):
		velocity = Vector2(0,-speed)
		animstate.play("walkleft")
	
func _physics_process(delta):
	if canmove == false:
		return
	move(delta)
	move_and_slide(velocity)