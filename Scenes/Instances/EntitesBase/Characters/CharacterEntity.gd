extends KinematicBody2D

enum movement_type {
	FREE,
	GRID
}

onready var stats = $Systems/Stats
onready var health = $Systems/Health
onready var SpriteHandler = $SpriteHandler
onready var BodySprites = $SpriteHandler/Body
onready var line = $Line2D

var RespawnPoints = []
var current_movement_type = movement_type.FREE
var lastpos   : Vector2 = Vector2()
var targetpos : Vector2 = Vector2()
var moveDir   : Vector2 = Vector2()

var nav_path          : Array
var nav_target_vector : Vector2
var nav_target_node
var nav_distance

export(int, "Player", "NPC") var CharacterType : int  = 1
export(int, "Male", "Female") var Gender : int  = 0
export(int, FLAGS, "Independent", "Hogwarts", "Death Eaters", "Auroras", "Nature", "Undead", "Vampires", "Wolfwalkers", "Clockworkers", "Water people", "Lumera Tribe") var faction = 0  
export(int, "Free", "Grid")  var MovementType  : int  = 1
export(bool) var changeSpritesWhenMoving       : bool = true
export(bool) var canMove                       : bool = true
export(int)  var tileSize                      : int  = 32

func _ready():
	#Movement setup
	match(MovementType):
		0:
			current_movement_type = movement_type.FREE
			$GridMovement_CollisionDetection.enabled = false
		1:
			current_movement_type = movement_type.GRID
			$GridMovement_CollisionDetection.enabled = true
			position = position.snapped(Vector2(tileSize, tileSize))
			lastpos  = position
			targetpos= position
			

func _physics_process(delta):
	line.global_position = Vector2.ZERO
	if(canMove):
		match(current_movement_type):
			movement_type.FREE:
				free_movement(delta)
			movement_type.GRID:
				grid_movement(delta)

func free_movement(delta):
	var velocity = moveDir
	if(moveDir.y == -1):
		SpriteHandler.PlayDirectionalAnimAll(13)
	if(moveDir.y == 1):
		SpriteHandler.PlayDirectionalAnimAll(10)
	if(moveDir.x == -1):
		SpriteHandler.PlayDirectionalAnimAll(11)
	if(moveDir.x == 1):
		SpriteHandler.PlayDirectionalAnimAll(12)
	if(moveDir == Vector2.ZERO):
		SpriteHandler.PlayIdleOnAllBasedOnDirection()
	velocity = velocity.normalized() * stats.movement_speed
	if(nav_path == null or nav_path == []):
		move_and_slide(velocity)
	else:
		nav_distance = stats.movement_speed * delta
		navigate()

func grid_movement(delta):
	if($GridMovement_CollisionDetection.is_colliding()):
		position = lastpos
		targetpos = lastpos
	else:
		position += stats.movement_speed * moveDir * delta
		
		if(position.distance_to(lastpos) >= tileSize - stats.movement_speed * delta):
			position = targetpos
		
	if(position == targetpos):
		lastpos = position
		targetpos += moveDir * tileSize
		
func generate_path_to_node(t):
	nav_path = Data.nav_world.get_simple_path(global_position, t.global_position, false)
	line.points = nav_path
	
func generate_path_to_vector2(vec : Vector2):
	nav_path = Data.nav_world.get_simple_path(global_position, vec, false)
	line.points = nav_path
	
func set_nav_path(path):
	nav_path = path
	
func set_nav_target_vec2(target):
	nav_target_vector = target
	
func set_nav_target_node(target):
	nav_target_node = target
	
func navigate():
	var last_point = self.global_position
	for index in range(nav_path.size()):
		var distance_between_points = last_point.distance_to(nav_path[0])
		if nav_distance <= distance_between_points:
			global_position = last_point.linear_interpolate(nav_path[0], nav_distance / distance_between_points)
			break
		elif nav_distance < 0.0 :
			global_position = nav_path[0]
			nav_path = []
			break
		nav_distance -= distance_between_points
		last_point = nav_path[0]
		nav_path.remove(0)
	
	#if(nav_path.size() > 1):
	#	moveDir = global_position.direction_to(nav_path[1]) * stats.movement_speed
	#	if(global_position.distance_to(nav_path[0]) >= 0.50):
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
