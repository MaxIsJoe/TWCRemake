extends "res://Scenes/Instances/EntitesBase/Characters/Health.gd"

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
