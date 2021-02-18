extends AudioStreamPlayer

##References to which audio player will be used##
onready var AmbiencePlayer = $Ambience
onready var UIPlayer = $UI
onready var FxPlayer = $FX

##Refereneces to audio that will be used##
var Amb_Hogwarts = {
	HA_ONE = "res://Sound/SFX/amb/ambicha1.ogg",
	HA_TWO = "res://Sound/SFX/amb/ambicha2.ogg",
	HA_THREE = "res://Sound/SFX/amb/ambicha3.ogg",
	HA_FOUR = "res://Sound/SFX/amb/ambicha4.ogg"
}

##The audio player that will be used to make sounds##
var AudioPlayer

##Settings##
var Settings_Volume_Master
var Settings_Volume_Ambience
var Settings_Volume_Music
var Settings_Volume_UI
var Settings_Volume_FX
	
##The main function that wil play sounds##
func PlaySound(sound, target, bus, volume, pitch):
	SetupPS(target, bus, volume, pitch)
	AudioPlayer.stream = sound
	AudioPlayer.play()
	if(Global.DEBUG_Mode): print(str("[Audio] playing -> " + str(sound)))
	

##Sets up the audio player##
func SetupPS(target, bus, volume, pitch):
	match target:
		0:
			AudioPlayer = FxPlayer
		1:
			AudioPlayer = AmbiencePlayer
		2:
			AudioPlayer = UIPlayer
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
