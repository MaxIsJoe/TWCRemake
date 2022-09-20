extends Node2D

var pl
var spawnpos

func TeleportPos(target, pos, sound):
	target.global_position = pos
	if(sound != null):
		PlaySoundOnSuccsefulTeleport(sound, pos)

func PlaySoundOnSuccsefulTeleport(sound, pos):
	var TeleportAudio = AudioStreamPlayer2D.new()
	TeleportAudio.stream = sound
	TeleportAudio.bus = "Sound Effects"
	TeleportAudio.position = pos
	add_child(TeleportAudio)
	TeleportAudio.play()
	await TeleportAudio.finished
	remove_child(TeleportAudio)
