extends Node
	
	
func PlaySound(sound, target, bus, volume, pitch):
	var AudioPlayer = target
	if(bus == null):
		AudioPlayer.bus = "Master"
	else:
		AudioPlayer.bus = bus
	if(pitch == null):
		AudioPlayer.pitch_scale = 1.0
	else:
		AudioPlayer.pitch_scale = pitch
	if(volume == null):
		AudioPlayer.volume_db = 0.0
	else:
		AudioPlayer.volume_db = volume
	AudioPlayer.stream = sound
	AudioPlayer.play()
	print("playing audio..")
