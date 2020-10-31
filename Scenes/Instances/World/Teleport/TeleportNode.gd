extends Area2D

export(bool) var Local = true
export(String) var NextScene
export(Vector2) var SpawnPostion
export(NodePath) var TeleportLocation
export(AudioStream) var Footstep_Sounds
#export(Range) var Pitch_Range

func _on_TeleportLocalNode_body_entered(body):
	if(body.is_in_group("Players")):
		if(Local):
			if(Footstep_Sounds != null):
				PlayAudio(body)
			body.position = get_node(TeleportLocation).position
		if(!Local):
			if(Footstep_Sounds != null):
				PlayAudio(body)
			Teleport.Move_To_Scene(NextScene, body, SpawnPostion)

func PlayAudio(body):
	randomize()
	var pitch = int(rand_range(-3,3))
	print("Audio Pitch :" + str(pitch))
	GlobalAudio.PlaySound(Footstep_Sounds,body.AudioLocal, "Sound Effects", null, pitch)
