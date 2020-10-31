extends Node

onready var ShootPoint = $ShootPoint

var Inflamri = load("res://Scenes/Instances/Actors/Spells/Projectiles/Inflamri.tscn")

func ShootSpell(Spell):
	var b
	match Spell:
		"inflamri":
			b = Inflamri.instance()
			b.init_spell(get_parent().LookingDirection, get_parent().PlayerName, get_parent().damage)
			b.transform = ShootPoint.global_transform
	if(b != null) : get_parent().get_parent().add_child(b)
