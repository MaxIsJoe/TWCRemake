extends "res://Scenes/Instances/EntitesBase/Characters/Health.gd"

export(NodePath) var HealthBar_PATH
onready var HealthBar = get_node(HealthBar_PATH)
	
	
func _ready():
	HealthBar._on_Player_hpupdate(HP, HP_MAX)

remotesync func TakeDamage(damage: int):
	.TakeDamage(damage)
	HealthBar._on_Player_hpupdate(HP, HP_MAX)

remotesync func BecomeAlive():
	.BecomeAlive()
	HealthBar._on_Player_hpupdate(HP, HP_MAX)
