extends Node
class_name Entity_Health

enum HealthState {
	ALIVE,
	UNCONSCIOUS,
	DEAD
}

@export var parent_PATH: NodePath
@onready var parent = get_node(parent_PATH)
@export var HealthTween_PATH: NodePath
@onready var HealthTween = get_node(HealthTween_PATH)
@export var Collision_PATH: NodePath
@onready var Collision = get_node(Collision_PATH)
@export var HP: int = 100
@export var HP_MAX: int = 100
@export var CanBeDamaged: bool = false
@export var EntityRotatesOnDeath: bool = true
@export var EntityCanRespawn: bool = true
@export var TimeToRespawn: float = 4.0

@export_enum(HealthState) var currentState
var lastDamagedBy : String

@onready var RespawnTimer = $Timer

var this_class = load("res://Scenes/Instances/EntitesBase/Characters/Health.gd")    

@rpc(any_peer, call_local) func TakeDamage(damage: int, damagedBy):
	if(CanBeDamaged):
		match currentState:
			HealthState.ALIVE:
				HP -= damage
			HealthState.UNCONSCIOUS:
				HP -= damage * 2
		if(damagedBy is PlayerEntity):
			lastDamagedBy = damagedBy.PlayerName
		else:
			lastDamagedBy = str(damagedBy.name)
	if(HP <= 0 and currentState != HealthState.DEAD):
		rpc_id(0, "BecomeAlivent")

@rpc(any_peer, call_local) func Heal(HealType: int, points_to_heal: int):
	match(HealType):
		0: #Instant Heal
			HP += points_to_heal
			if(HP > HP_MAX):
				HP = HP_MAX
		1: #Heal over time
			pass #add later
	
@rpc(any_peer, call_local) func BecomeAlive():
	currentState = HealthState.ALIVE
	parent.canMove = true
	HP = HP_MAX
	
	var sprites = parent.SpriteHandler
	sprites.rotation_degrees = 0
	parent.Respawn()
	Collision.set_deferred("disabled", false)

@rpc(any_peer, call_local) func BecomeAlivent():
	currentState = HealthState.DEAD
	parent.canMove = false
	
	var sprites = parent.SpriteHandler
	if(EntityRotatesOnDeath):
		HealthTween.interpolate_property(sprites, "rotation_degrees", sprites.rotation_degrees, 90.0, 0.4 ,Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
		HealthTween.start()
	RespawnTimer.wait_time = TimeToRespawn
	RespawnTimer.start()
	Collision.set_deferred("disabled", true)


func _on_Timer_timeout():
	if(EntityCanRespawn):
		rpc_id(0, "BecomeAlive")
		$Timer.stop()
	else:
		parent.queue_free()
