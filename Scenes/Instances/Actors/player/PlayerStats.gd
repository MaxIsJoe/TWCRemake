extends "res://Scenes/Instances/EntitesBase/Characters/Stats.gd"

export(NodePath) var parent_PATH
onready var parent = get_node(parent_PATH)
export(NodePath) var ManaBar_PATH
onready var ManaBar = get_node(ManaBar_PATH)

var XP     : int = 0
var XP_MAX : int = 100

var statpoints   : int = 0
var spellppoints : int = 0

func _ready():
	ManaBar._on_Player_mpupdate(mana, mana_max)

func gainXP(XP_to_gain: int):
	XP = XP_to_gain
	levelupcheck()

func levelupcheck():
	if(XP >= XP_MAX):
		level += 1
		XP_MAX *= level / 2 #This is temporary. Change later.
		XP = 0
		statpoints += 1
		parent.LevelUpAnim.play("FadeInFadeOut")

func UseMana(manapoints : int):
	if(mana >= mana_max):
		mana -= manapoints
		ManaBar._on_Player_mpupdate(mana, mana_max)
