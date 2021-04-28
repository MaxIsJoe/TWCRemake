extends "res://Scenes/Instances/EntitesBase/Characters/Stats.gd"

var XP = 0
var XP_MAX = 100

var statpoints = 0
var spellppoints = 0


func gainXP(XP_to_gain: int):
	XP = XP_to_gain
	levelupcheck()

func levelupcheck():
	if(XP >= XP_MAX):
		level += 1
		XP_MAX *= level / 2 #This is temporary. Change later.
		XP = 0
		statpoints += 1
		#LevelUpAnim.play("FadeInFadeOut")
