extends Node

onready var ShootPoint = $ShootPoint

var SpellsOnCoolDown = []

func PutSpellOnCoolDown(spell, cooldown):
	match spell:
		"Episkey":
			SpellsOnCoolDown.append()
			

master func ShootSpell(Spell):
	var b
	match Spell:
		"inflamri":
			b = Data.Inflamri.instance()
			b.rpc_id(0, "init_spell_shoot", get_parent().LookingDirection, get_parent().PlayerName, get_parent().damage)
			b.transform = ShootPoint.global_transform
	if(b != null) : Network.PlayerContainer.add_child(b)
	
master func TargetSpell(Spell, Target):
	var b
	match Spell:
		"Episkey":
			b = Data.Episkey.instance()
			b.init_spell_target(2, get_parent().PlayerName, "heal", 5, Target)
			b.transform = Target.TargertPoint.transform
	if(b != null) : Target.add_child(b)
