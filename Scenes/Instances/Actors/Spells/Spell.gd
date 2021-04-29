extends Node2D

export(int) var SpellDamage = 10
export(float) var SpellSpeed = 240.0
export(float) var SpellTime = 2 #Max time allowed for it to travel in a scene
export(bool) var TargetSpell = false

var dmg
var caster
var dir = transform.x

var timer

func _init():
	timer = Timer.new()
	add_child(timer)
	timer.autostart = true
	timer.wait_time = SpellTime
	timer.connect("timeout", self, "_timeout")
	self.set_physics_process(false)

func _timeout():
	queue_free()

func _physics_process(delta):
	if(!TargetSpell):
		UpdateSpellPosition(delta)

func UpdateSpellPosition(delta):
	var smooth_mov = position + (dir * SpellSpeed * delta)
	position = lerp(position, smooth_mov, 0.5)

remotesync func init_spell_shoot(caster_network_id):
	var direction_animation
	var CasterName
	var final_dmg
	if(caster_network_id != 1):
		direction_animation = NetworkManager.Network.world_state[caster_network_id].get("LD")
		CasterName = NetworkManager.Network.world_state[caster_network_id].get("N")#For damage logging and death messages
		final_dmg  = NetworkManager.Network.world_state[caster_network_id].get("D") + SpellDamage #Combine the base damage of the spell with the player's damage
	else:
		direction_animation = Data.Player.LookingDirection
		CasterName = Data.Player.PlayerName
		final_dmg = Data.Player.stats.damage
	match direction_animation: #What animation and direction the spell go to?
		0:
			$AnimatedSprite.play("up")
			dir = -transform.y
		3:
			$AnimatedSprite.play("down")
			dir = transform.y
		1:
			$AnimatedSprite.play("left")
			dir = -transform.x
		2:
			$AnimatedSprite.play("right")
			dir = transform.x
	dmg = final_dmg
	if(get_tree().get_network_unique_id() != 1): self.set_physics_process(true)
	
remotesync func init_spell_target(direction_animation, casterName, effect, value, target):
	match direction_animation:
		0:
			$AnimatedSprite.play("up")
			dir = -transform.y
		3:
			$AnimatedSprite.play("down")
			dir = transform.y
		1:
			$AnimatedSprite.play("left")
			dir = -transform.x
		2:
			$AnimatedSprite.play("right")
			dir = transform.x
	caster = casterName
	match effect:
		"heal":
			target.healthregen(value)
			$AnimatedSprite.play("right")
	if(get_tree().get_network_unique_id() != 1): self.set_physics_process(true)

remotesync func RemoveSpellFromWorld(): #This should avoid some RPC cache errors when a spell runs out of time or hits something
	queue_free()


func _on_Area2D_body_entered(body):
	if(!TargetSpell):
		if(body.is_in_group("Players")):
			body.rpc_id(int(body.name), "takedamage", dmg)
			queue_free()
		if(body.is_in_group("Enemies")):
			body.rpc("takedamage", dmg)
			queue_free()
		else:
			queue_free()
