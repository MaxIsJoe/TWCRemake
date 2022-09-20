extends Node2D

#export var TeleportToScene: String
@export var TeleportLocation: Vector2
@export var TeleportSound: AudioStream = load("res://Sound/SFX/teleports/poof_simple.wav")
@export var UsesNodeToTeleport: bool = false
@export var TeleportLocationNode: NodePath

var teleportNode : Marker2D

@onready var audio = $Area2D/AudioStreamPlayer2D

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
