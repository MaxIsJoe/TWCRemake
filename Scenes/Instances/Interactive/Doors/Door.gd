extends Node2D

#onready var Colider = $Collision
onready var AreaCollision = $Area2D/AreaCollision
onready var spriteanim = $AnimatedSprite
onready var timer = $Timer
onready var Occluder = $Occluder

#export(bool) var CanBeBroken = false

var IsOpen

export(bool) var IsLocked = false
#var playerlist
#var DoorHealth = 3000


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
				AreaCollision.set_disabled(true)
				spriteanim.play("Opening")
				Occluder.hide()
				timer.start()
		

func _on_Timer_timeout():
	spriteanim.play("Closing")
	IsOpen = false
	AreaCollision.set_disabled(false)
	Occluder.show()
	
	
