extends Node2D

onready var AreaCollision = $Area2D/AreaCollision
onready var StaticcCollision = $CollisionShape2D
onready var spriteanim = $AnimatedSprite
onready var timer = $Timer
onready var Occluder = $Occluder


var IsOpen

export(bool) var IsLocked = false



func _ready():
	IsOpen = false
	spriteanim.play("Idle")
	

func _on_Area2D_body_entered(body):
	if(body.is_in_group("Players")):
		if(IsLocked):
			return
		else:
			if IsOpen == false :
				IsOpen = true
				#Colider.set_disabled(true)
				AreaCollision.call_deferred("set_disabled", true)
				StaticcCollision.call_deferred("set_disabled", true)
				spriteanim.play("Opening")
				Occluder.hide()
				timer.start()
		

func _on_Timer_timeout():
	spriteanim.play("Closing")
	IsOpen = false
	AreaCollision.call_deferred("set_disabled", false)
	StaticcCollision.call_deferred("set_disabled", false)
	Occluder.show()
	
	
