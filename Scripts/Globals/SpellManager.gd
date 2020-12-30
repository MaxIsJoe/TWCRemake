extends Node

var ShootPoint

var SpellsOnCoolDown = []

func PutSpellOnCoolDown(spell, cooldown):
	match spell:
		"Episkey":
			SpellsOnCoolDown.append()
			

remotesync func ShootSpell(Spell):
	var b
	ShootPoint = Data.Player.Shootpoint
	match Spell:
		"inflamri":
			b = Data.Inflamri.instance()
			b.transform = ShootPoint.global_transform
	if(b != null): 
		add_child(b)
		b.rpc_id(0, "init_spell_shoot", Data.Player.LookingDirection, Data.Player.PlayerName, Data.Player.damage)
	
remotesync func TargetSpell(Spell, Target):
	var b
	match Spell:
		"Episkey":
			b = Data.Episkey.instance()
			b.transform = Target.TargertPoint.transform
	if(b != null): 
		Target.add_child(b)
		b.init_spell_target(2, Data.Player.PlayerName, "heal", 5, Target)
