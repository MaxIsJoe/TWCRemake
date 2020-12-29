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


func _timeout():
	queue_free()

func _physics_process(delta):
	if(!TargetSpell):
		rpc_unreliable_id(0, "UpdateSpellPosition", delta)

master func UpdateSpellPosition(delta):
	position += dir * SpellSpeed * delta

master func init_spell_shoot(direction_animation, casterName, damage):
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
	dmg = damage + SpellDamage
	
master func init_spell_target(direction_animation, casterName, effect, value, target):
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
