extends Node

var ShootPoint
var SpellsOnCoolDown = []

func PutSpellOnCoolDown(spell, cooldown):
	match spell:
		"Episkey":
			SpellsOnCoolDown.append()
			

remotesync func ShootSpell(Spell, caster_network_id):
	var b
	NetworkManager.Network.SendSpellState()
	ShootPoint = NetworkManager.Network.world_state[caster_network_id].get("SP")
	match Spell:
		"inflamri":
			b = Data.Inflamri.instance()
			b.name = str(NetworkManager.Network.spells_ID)
			b.transform = ShootPoint
	if(b != null): 
		add_child(b)
		b.rpc("init_spell_shoot", caster_network_id)
	
remotesync func TargetSpell(Spell, Target):
	var b
	match Spell:
		"Episkey":
			b = Data.Episkey.instance()
			b.set_network_master(get_tree().get_rpc_sender_id())
			b.transform = Target.TargertPoint.transform
	if(b != null): 
		Target.add_child(b)
		b.init_spell_target(2, Data.Player.PlayerName, "heal", 5, Target)

func SetMaster():
	self.set_network_master(1)
