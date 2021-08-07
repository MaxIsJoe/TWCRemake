extends Node2D

#export(String) var TeleportToScene
export(Vector2) var TeleportLocation
export(AudioStream) var TeleportSound = load("res://Sound/SFX/teleports/poof_simple.wav")
export(bool) var UsesNodeToTeleport = false
export(NodePath) var TeleportLocationNode

var teleportNode : Position2D

onready var audio = $Area2D/AudioStreamPlayer2D

func _ready():
	if(UsesNodeToTeleport):
		teleportNode = get_node(TeleportLocationNode)

func _on_Area2D_body_entered(body):
	if(body.is_in_group("Players")):
		audio.play()
		if(UsesNodeToTeleport):
			Teleport.TeleportPos(body, teleportNode.global_position, TeleportSound)
		else:
			Teleport.TeleportPos(body, TeleportLocation, TeleportSound)
