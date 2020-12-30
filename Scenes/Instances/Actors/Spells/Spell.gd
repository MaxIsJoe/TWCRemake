extends Node2D

export(int) var SpellDamage = 10
export(float) var SpellSpeed = 240.0
export(float) var SpellTime = 2 #Max time allowed for it to travel in a scene
export(bool) var TargetSpell = false

var dmg
var caster
var dir = transform.x

var timer
var exit = false

func _init():
	timer = Timer.new()
	add_child(timer)
	timer.autostart = true
	timer.wait_time = SpellTime
	timer.connect("timeout", self, "_timeout")


func _timeout():
	exit = true
	queue_free()

func _physics_process(delta):
	if(!TargetSpell):
		rpc_id(0, "UpdateSpellPosition", delta)

remotesync func UpdateSpellPosition(delta):
	if(exit == false): #To prevent the RPC cache error
		var smooth_mov = position + (dir * SpellSpeed * delta)
		position = lerp(position, smooth_mov, 0.5)

remotesync func init_spell_shoot(direction_animation, casterName, damage):
	if(casterName == null or dmg == null): #This is just to be safe
		push_warning(str("[Spell] - ERROR - CasterName or dmg is null. -> " + casterName + " " + str(dmg)))
		print("[Spell] - Attempting to fix this issue automatically")
		if(Data.Player == null):
			push_warning("[Spell] - Data.Player does not exist! Failed!")
		else:
			if(Data.Player.damage != null):
				damage = Data.Player.damage
				print("[Spell] - Success! Damage is now ->", damage)
			else:
				print("[Spell] - Player's damage is null! Failed!")
			if(Data.Player.PlayerName != null):
				casterName = Data.Player.PlayerName
				print("[Spell] - Success! casterName is now ->", casterName)
			else:
				print("[Spell] - Player's name is null! Failed!")
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
	caster = casterName #For damage logging and death messages
	var final_dmg = damage + SpellDamage #Combine the base damage of the spell with the player's damage
	dmg = final_dmg
	
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


func _on_Area2D_body_entered(body):
	if(!TargetSpell):
		if(body.is_in_group("Players")):
			body.rpc("takedamage", dmg)
			queue_free()
		if(body.is_in_group("Enemies")):
			body.rpc("takedamage", dmg)
			queue_free()
		else:
			queue_free()
