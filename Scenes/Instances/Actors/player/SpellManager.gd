extends Node

onready var ShootPoint = $ShootPoint

var Inflamri = load("res://Scenes/Instances/Actors/Spells/Projectiles/Inflamri.tscn")
var Episkey = load("res://Scenes/Instances/Actors/Spells/Target/Episkey.tscn")

var SpellsOnCoolDown = []

func PutSpellOnCoolDown(spell, cooldown):
	match spell:
		"Episkey":
			SpellsOnCoolDown.append()
			

func ShootSpell(Spell):
	var b
	match Spell:
		"inflamri":
			b = Inflamri.instance()
			b.init_spell_shoot(get_parent().LookingDirection, get_parent().PlayerName, get_parent().damage)
			b.transform = ShootPoint.global_transform
	if(b != null) : get_parent().get_parent().add_child(b)
	
func TargetSpell(Spell, Target):
	var b
	match Spell:
		"Episkey":
			b = Episkey.instance()
			b.init_spell_target(2, get_parent().PlayerName, "heal", 5, Target)
			b.transform = Target.TargertPoint.transform
	if(b != null) : Target.add_child(b)
