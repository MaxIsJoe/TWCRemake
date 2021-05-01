extends KinematicBody2D

enum movement_type {
	FREE,
	GRID
}

onready var stats = $Systems/Stats
onready var health = $Systems/Health
onready var SpriteHandler = $SpriteHandler
onready var BodySprites = $SpriteHandler/Body

var RespawnPoints = []
var current_movement_type = movement_type.FREE
var lastpos   : Vector2 = Vector2()
var targetpos : Vector2 = Vector2()
var moveDir   : Vector2 = Vector2()

export(int, "Player", "NPC") var CharacterType : int  = 1
export(int, "Male", "Female") var Gender : int  = 0
export(int, FLAGS, "Independent", "Hogwarts", "Death Eaters", "Auroras", "Nature") var faction = 0  
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
	if(canMove):
		match(current_movement_type):
			movement_type.FREE:
				free_movement()
			movement_type.GRID:
				grid_movement(delta)

func free_movement():
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
	move_and_slide(velocity)

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

func Respawn():
	if(RespawnPoints.size() == 0):
		push_error("[Health] : No respawn points avaliable for " + name)
		return
	randomize()
	var point = RespawnPoints[rand_range(0,RespawnPoints.size())]
	Teleport.TeleportPos(self, point, null)
	health.BecomeAlive()
