extends Area2D

export(NodePath) var TeleportLocation
export(AudioStream) var Footstep_Sounds
#export(Range) var Pitch_Range

func _on_TeleportLocalNode_body_entered(body):
	if(body.is_in_group("Players")):
		if(Footstep_Sounds != null):
			randomize()
			var pitch = int(rand_range(-3,3))
			print("Audio Pitch :" + str(pitch))
			GlobalAudio.PlaySound(Footstep_Sounds,body.AudioLocal, "Sound Effects", null, pitch)
		body.position = get_node(TeleportLocation).position
