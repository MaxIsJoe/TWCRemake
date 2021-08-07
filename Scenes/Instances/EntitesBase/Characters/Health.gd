extends Node

export(NodePath) var parent_PATH
onready var parent = get_node(parent_PATH)
export(NodePath) var HealthTween_PATH
onready var HealthTween = get_node(HealthTween_PATH)
export(NodePath) var Collision_PATH
onready var Collision = get_node(Collision_PATH)
export(int) var HP = 100
export(int) var HP_MAX = 100
export(bool) var CanBeDamaged = false
export(bool) var EntityRotatesOnDeath = true
export(bool) var EntityCanRespawn = true
export(float) var TimeToRespawn = 4.0

var currentState = HealthState.ALIVE
var lastDamagedBy : String

onready var RespawnTimer = $Timer

var this_class = load("res://Scenes/Instances/EntitesBase/Characters/Health.gd")    

enum HealthState {
	ALIVE,
	UNCONSCIOUS,
	DEAD
}


remotesync func TakeDamage(damage: int, damagedBy: String = "unkown"):
	if(CanBeDamaged):
		match currentState:
			HealthState.ALIVE:
				HP -= damage
			HealthState.UNCONSCIOUS:
				HP -= damage * 2
		lastDamagedBy = damagedBy
	if(HP <= 0 and currentState != HealthState.DEAD):
		rpc_id(0, "BecomeAlivent")

remotesync func Heal(HealType: int, points_to_heal: int):
	match(HealType):
		0: #Instant Heal
			HP += points_to_heal
			if(HP > HP_MAX):
				HP = HP_MAX
		1: #Heal over time
			pass #add later
	
remotesync func BecomeAlive():
	currentState = HealthState.ALIVE
	parent.canMove = true
	HP = HP_MAX
	
	var sprites = parent.SpriteHandler
	sprites.rotation_degrees = 0
	parent.Respawn()
	Collision.set_deferred("disabled", false)

remotesync func BecomeAlivent():
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
