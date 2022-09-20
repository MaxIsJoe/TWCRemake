extends Area2D

@export var TeleportLocation: NodePath
@export var Footstep_Sounds: AudioStream
#export var Pitch_Range: Range

func _ready():
	$AudioStreamPlayer2D.stream = Footstep_Sounds

func _on_TeleportLocalNode_body_entered(body):
	if(body.is_in_group("Players")):
			if(Footstep_Sounds != null):
				PlayAudio()
			Teleport.TeleportPos(body, get_node(TeleportLocation).position, Footstep_Sounds)

func PlayAudio():
	randomize()
	var pitch = randf_range(0.75,1.30)
	if(pitch == 0.0):
		pitch = 0.1
	$AudioStreamPlayer2D.pitch_scale = pitch
	$AudioStreamPlayer2D.play()
