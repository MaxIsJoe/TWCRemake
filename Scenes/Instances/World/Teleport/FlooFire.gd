extends Node2D

#export(String) var TeleportToScene
export(Vector2) var TeleportLocation
export(AudioStream) var TeleportSound = load("res://Sound/SFX/teleports/poof_simple.wav")

onready var audio = $Area2D/AudioStreamPlayer2D

func _on_Area2D_body_entered(body):
	if(body.is_in_group("Players")):
		audio.play()
		Teleport.TeleportPos(body, TeleportLocation, TeleportSound)
