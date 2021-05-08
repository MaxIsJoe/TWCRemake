extends "res://Scenes/Instances/EntitesBase/Characters/CharacterEntity.gd"

export(int) var SpawnerID: int = 0
export(int, "Melee", "Caster") var AttackType = 0
export(float) var AttackRange = 15
export(float) var AttackCooldown = 1
export(float) var AlertExtraRange = 35
export(bool) var IsLegendary = false

onready var LineOfSight = $LineOfSight

var zoneParent

var spawn_position : Vector2
var default_raycast_range : float

remotesync var target
var current_state = AI_states.IDLE
var player_spotted : bool = false
var canAttack : bool = true

enum AI_states {
	IDLE,
	WANDER,
	SEARCH,
	ATTACK,
	RETREAT
}

func _ready():
	default_raycast_range = LineOfSight.cast_to.x
	$AttackCooldown.wait_time = AttackCooldown

func _physics_process(delta):
	SeekPlayer()
	LookAtTarget()
	match current_state:
		AI_states.IDLE:
			AI_IDLE()
		AI_states.ATTACK:
			AI_ATTACK(delta)
		AI_states.RETREAT:
			AI_RETREAT(delta)
			

func GetEnemyData():
	var data = {
		"pid": SpawnerID,
		"id": name,
		"P": global_position, 
		"A": SpriteHandler.currentDir, 
	}
	return data
	
func UpdateEnemyData(data):
	global_position = data[str(name)]["P"]
	SpriteHandler.currentDir = data[str(name)]["A"]
	
	SpriteHandler.PlayDirectionalAnimAll(SpriteHandler.currentDir)

func HrdMoveTo(thing):
	lerp(self.position, thing.position, 0.8)

func AI_IDLE():
	nav_path = []

func AI_ATTACK(delta):
	match AttackType:
		0:
			if(GetDistance2SpawnPosition() > 1100):
				Retreat()
			if(Global.GetDistance2Player(self) <= AttackRange):
				MeleeAttackLogic(target)
			navigate()
			
func AI_RETREAT(delta):
	if(global_position.distance_to(spawn_position) <= rand_range(25, 55)):
		moveDir = Vector2.ZERO
		current_state = AI_states.IDLE
		
func check_player_in_detection() -> bool:
	var collider = LineOfSight.get_collider()
	if collider and collider.is_in_group("Players"):
		player_spotted = true
		return true
	return false
		
func MeleeAttackLogic(victim):
	if(victim.is_in_group("Players")):
		if(canAttack):
			victim.rpc("takedamage", stats.damage)
			canAttack = false
			$AttackCooldown.start()
		
func SeekPlayer():
	if(current_state == AI_states.IDLE or current_state == AI_states.SEARCH or current_state == AI_states.WANDER):
		var player = zoneParent.GetNearestPlayer()
		if(player != null):
			LineOfSight.look_at(player.global_position)
			if(check_player_in_detection() == true):
				if(current_state == AI_states.RETREAT and GetDistance2SpawnPosition() > 1000):
					return
				SetAttackTarget(player)

func GetDistance2ZoneParent():
	return global_position.distance_to(zoneParent.global_position)
	
func GetDistance2SpawnPosition():
	return global_position.distance_to(spawn_position)

func SetAttackTarget(thevictim):
	target = thevictim
	generate_path_to_node(target)
	navigate()
	current_state = AI_states.ATTACK
	LineOfSight.cast_to.x = LineOfSight.cast_to.x + AlertExtraRange
	$ChaseTimeout.start()
	
func BecomeIdle():
	moveDir = Vector2.ZERO
	target = null
	current_state = AI_states.IDLE
	LineOfSight.cast_to.x = default_raycast_range
	
func Retreat():
	target = null
	generate_path_to_vector2(spawn_position)
	navigate()
	current_state = AI_states.RETREAT

func LookAtTarget():
	if(target != null):
		LineOfSight.look_at(target.global_position)

func _on_RefreshNav_timeout():
	if(player_spotted and target != null):
		generate_path_to_node(target)


func _on_ChaseTimeout_timeout():
	if(check_player_in_detection() == false):
		if(GetDistance2SpawnPosition() > 1000):
			Retreat()
		else:
			BecomeIdle()
	else:
		$ChaseTimeout.start()


func _on_AttackCooldown_timeout():
	canAttack = true
