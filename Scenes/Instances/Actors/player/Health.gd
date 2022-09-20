extends "res://Scenes/Instances/EntitesBase/Characters/Health.gd"

@export var HealthBar_PATH: NodePath
@onready var HealthBar = get_node(HealthBar_PATH)
@export var CanGrayscaleVision: bool = true
	
func _ready():
	HealthBar._on_Player_hpupdate(HP, HP_MAX)

@rpc(any_peer, call_local) func TakeDamage(damage: int, damageBy):
	super.TakeDamage(damage, damageBy)
	HealthBar._on_Player_hpupdate(HP, HP_MAX)

@rpc(any_peer, call_local) func BecomeAlive():
	super.BecomeAlive()
	HealthBar._on_Player_hpupdate(HP, HP_MAX)

