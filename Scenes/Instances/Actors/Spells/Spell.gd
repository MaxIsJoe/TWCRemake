extends Node2D

export(int) var SpellDamage = 10
export(float) var SpellSpeed = 240.0
export(float) var SpellTime = 2 #Max time allowed for it to travel in a scene


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
	position += dir * SpellSpeed * delta

func init_spell(direction_animation, casterName, damage):
	print(direction_animation)
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


func _on_Area2D_body_entered(body):
	if(body.is_in_group("Players")):
		body.takedamage(dmg)
		queue_free()
	if(body.is_in_group("Enemies")):
		body.takedamage(dmg)
		queue_free()
	else:
		queue_free()
