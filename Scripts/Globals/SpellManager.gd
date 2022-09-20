extends Node

var ShootPoint
var SpellsOnCoolDown = []

func PutSpellOnCoolDown(spell, cooldown):
	match spell:
		"Episkey":
			SpellsOnCoolDown.append(spell)
			

@rpc(any_peer, call_local) func ShootSpell(Spell, caster_network_id):
	var b
	NetworkManager.Network.SendSpellState()
	if(caster_network_id != 1):
		ShootPoint = NetworkManager.Network.world_state[caster_network_id].get("SP")
	else:
		ShootPoint = Data.Player.Shootpoint.global_transform
	match Spell:
		"inflamri":
			b = Data.Inflamri.instantiate()
			b.name = str(NetworkManager.Network.spells_ID)
			b.transform = ShootPoint
	if(b != null): 
		add_child(b)
		b.rpc("init_spell_shoot", caster_network_id)
	
@rpc(any_peer, call_local) func TargetSpell(Spell, Target):
	var b
	match Spell:
		"Episkey":
			b = Data.Episkey.instantiate()
			b.set_multiplayer_authority(get_tree().get_remote_sender_id())
			b.transform = Target.TargertPoint.transform
	if(b != null): 
		Target.add_child(b)
		b.init_spell_target(2, Data.Player.PlayerName, "heal", 5, Target)

func SetMaster():
	self.set_multiplayer_authority(1)
