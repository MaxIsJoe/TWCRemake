extends Node

var ShootPoint
var SpellsOnCoolDown = []

func PutSpellOnCoolDown(spell, cooldown):
	match spell:
		"Episkey":
			SpellsOnCoolDown.append()
			

remotesync func ShootSpell(Spell, caster_network_id):
	var b
	ShootPoint = Network.world_state[caster_network_id].get("SP")
	match Spell:
		"inflamri":
			b = Data.Inflamri.instance()
			b.transform = ShootPoint
	if(b != null): 
		add_child(b)
		if(has_node(b.name)): b.rpc_id(0, "init_spell_shoot", caster_network_id)
	
remotesync func TargetSpell(Spell, Target):
	var b
	match Spell:
		"Episkey":
			b = Data.Episkey.instance()
			b.transform = Target.TargertPoint.transform
	if(b != null): 
		Target.add_child(b)
		b.init_spell_target(2, Data.Player.PlayerName, "heal", 5, Target)

func SetMaster():
	self.set_network_master(1)
