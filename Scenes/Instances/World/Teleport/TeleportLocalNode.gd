extends Area2D

export(NodePath) var TeleportLocation
export(AudioStream) var Footstep_Sounds

func _ready():
	$AudioStreamPlayer2D.stream = Footstep_Sounds

func _on_TeleportLocalNode_body_entered(body):
	if(body.is_in_group("Players")):
		if(Footstep_Sounds != null):
			$AudioStreamPlayer2D.play()
		body.position = get_node(TeleportLocation).position
