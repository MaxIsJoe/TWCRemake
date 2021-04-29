extends "res://Scenes/Instances/EntitesBase/Characters/Health.gd"

export(NodePath) var HealthBar_PATH
onready var HealthBar = get_node(HealthBar_PATH)
	
	
func _ready():
	HealthBar._on_Player_hpupdate(HP, HP_MAX)

func TakeDamage(damage: int):
	if(CanBeDamaged):
		HP -= damage
		if(HP <= 0):
			BecomeAlivent()
	HealthBar._on_Player_hpupdate(HP, HP_MAX)


func BecomeAlivent():
	currentState = HealthState.DEAD
	parent.canMove = false
	
	var sprites = parent.SpriteHandler
	HealthTween.interpolate_property(sprites, "rotation_degrees", sprites.rotation_degrees, 90.0, 0.4 ,Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	HealthTween.start()
	RespawnTimer.wait_time = TimeToRespawn
	RespawnTimer.start()

func BecomeAlive():
	currentState = HealthState.ALIVE
	parent.canMove = true
	
	var sprites = parent.SpriteHandler
	sprites.rotation_degrees = 0
	parent.Respawn()
