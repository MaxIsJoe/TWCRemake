extends Node2D

export(String) var TeleportToScene
export(Vector2) var TeleportLocation




func _on_Area2D_body_entered(body):
	if(body.is_in_group("Players")):
		GlobalAudio.PlaySound(load("res://Sound/SFX/teleports/poof_simple.wav"), Data.Player.AudioLocal, null, null, null)
		Teleport.Move_To_Scene(TeleportToScene, body, TeleportLocation)
