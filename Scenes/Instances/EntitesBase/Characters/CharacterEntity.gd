extends KinematicBody2D
class_name MobEntity

onready var LineOfSight : RayCast2D = $LineOfSight
onready var stats = $Systems/Stats
onready var health = $Systems/Health
onready var SpriteHandler = $SpriteHandler
onready var BodySprites = $SpriteHandler/Body
onready var line = $Line2D

var RespawnPoints = []
var lastpos   : Vector2 = Vector2()
var targetpos : Vector2 = Vector2()
var moveDir   : Vector2 = Vector2()

var nav_path          : Array
var nav_target_vector : Vector2
var nav_target_node
var nav_distance
var nav_antistuck_time: int = 0
var navAreaParent

export(int, "Player", "NPC") var CharacterType : int  = 1
export(int, "Male", "Female") var Gender : int  = 0
export(int, FLAGS, "Independent", "Hogwarts", "Death Eaters", "Auroras", "Nature", "Undead", "Vampires", "Wolfwalkers", "Clockmasters", "Water people", "Lumera Tribe") var faction = 0  
export(int, "Free", "Grid")  var MovementType  : int  = 1
export(bool) var changeSpritesWhenMoving       : bool = true
export(bool) var rotatesSpritesTowardMovement  : bool = false
export(bool) var canMove                       : bool = true
export(int)  var tileSize                      : int  = 32
export(int)  var EXPGivenOnDeath               : int  = 100
export(int)  var GoldGivenOnDeath              : int  = 100

func _ready():
	if(navAreaParent == null):
		navAreaParent = Data.nav_world
	else:
		print(navAreaParent.name)

func _physics_process(delta):
	line.global_position = Vector2.ZERO
	if(canMove):
		movement(delta)

func movement(delta):
	var velocity = moveDir
	velocity = velocity.normalized() * stats.movement_speed
	if(nav_path == null or nav_path == []):
		move_and_slide(velocity)
	else:
		nav_distance = stats.movement_speed * delta
		navigate(delta)
	if(changeSpritesWhenMoving):
		CheckForAnimationsForMovement()

func CheckForAnimationsForMovement():
	if(moveDir.y < -0.1):
		SpriteHandler.PlayDirectionalAnimAll(13) #up
	if(moveDir.y > 0.1):
		SpriteHandler.PlayDirectionalAnimAll(10) #down
	if(moveDir.x < -0.1):
		SpriteHandler.PlayDirectionalAnimAll(11) #left
	if(moveDir.x > 0.1):
		SpriteHandler.PlayDirectionalAnimAll(12) #right
	if(moveDir == Vector2.ZERO):
		SpriteHandler.PlayIdleOnAllBasedOnDirection()
	
	if(nav_path != [] and rotatesSpritesTowardMovement):
		RotateSpritesTowardsVector(nav_path[0])
		
remotesync func RotateSpritesTowardsVector(vec : Vector2):
	SpriteHandler.look_at(vec)
	
remotesync func ResetSpritesRotation():
	SpriteHandler.rotation_degrees = 0

func generate_path_to_node(t):
	nav_path = navAreaParent.get_simple_path(global_position, t.global_position, false)
	line.points = nav_path
	
func generate_path_to_vector2(vec : Vector2):
	nav_path = navAreaParent.get_simple_path(global_position, vec, false)
	line.points = nav_path
	
func set_nav_path(path):
	nav_path = path
	
func set_nav_target_vec2(target):
	nav_target_vector = target
	
func set_nav_target_node(target):
	nav_target_node = target
	
func navigate(delta):
	var last_point = self.global_position
	for _index in range(nav_path.size()):
		nav_antistuck_time += 1
		if(nav_antistuck_time >= 900):
				global_position = nav_path[0]
				nav_antistuck_time = 0
				break
		var distance_between_points = last_point.distance_to(nav_path[0])
		if nav_distance <= distance_between_points:
			var direction = (nav_path[0] - global_position).normalized()
			moveDir = moveDir.move_toward(direction * stats.movement_speed, 300 * delta)
			if(nav_path.size() > 1):
				moveDir = global_position.direction_to(nav_path[1]) * stats.movement_speed
				if(global_position.distance_to(nav_path[0]) >= 12.50):
					nav_path.pop_front()
			move_and_slide(moveDir)
			#global_position = last_point.linear_interpolate(nav_path[0], nav_distance / distance_between_points)
			break
		elif nav_distance < 0.0 :
			global_position = nav_path[0]
			nav_path = []
			nav_antistuck_time = 0
			break
		nav_distance -= distance_between_points
		last_point = nav_path[0]
		nav_path.remove(0)
		nav_antistuck_time = 0
	
	#if(nav_path.size() > 1):
	#	moveDir = global_position.direction_to(nav_path[1]) * stats.movement_speed
	#	if(global_position.distance_to(nav_path[0]) >= 2.50):
	#		nav_path.pop_front()
			
func stop_navigating():
	moveDir = Vector2.ZERO
	nav_path = []

func Respawn():
	if(RespawnPoints.size() == 0):
		push_error("[Health] : No respawn points avaliable for " + name)
		return
	randomize()
	var point = RespawnPoints[rand_range(0,RespawnPoints.size())]
	Teleport.TeleportPos(self, point, null)
	health.BecomeAlive()

###Audio
func audio_setTrack(audionode: AudioStreamPlayer2D, audiotrack: Object):
	audionode.stream = audiotrack

func audio_playCurrentTrack(audionode: AudioStreamPlayer2D, randomizePitch: bool):
	if(randomizePitch == true):
		randomize()
		audionode.pitch_scale = rand_range(0.75, 1.25)
	else:
		audionode.pitch_scale = 1
		
	audionode.play()
	
func audio_stopTrack(audionode: AudioStreamPlayer2D):
	audionode.stop()

