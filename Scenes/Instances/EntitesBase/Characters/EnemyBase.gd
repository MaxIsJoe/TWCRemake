extends "res://Scenes/Instances/EntitesBase/Characters/CharacterEntity.gd"

export(int) var SpawnerID: int = 0
export(int, "Melee", "Caster") var AttackType = 0
export(float) var AttackRange = 35
export(bool) var IsLegendary = false

onready var LineOfSight = $LineOfSight

var zoneParent

var spawn_position : Vector2

remotesync var target
var current_state = AI_states.IDLE
var player_spotted : bool = false

enum AI_states {
	IDLE,
	WANDER,
	SEARCH,
	ATTACK,
	RETREAT
}

func _physics_process(delta):
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
	var player = zoneParent.GetNearestPlayer()
	if(player != null):
		LineOfSight.look_at(player.global_position)
		if(check_player_in_detection() == true):
			if(current_state == AI_states.RETREAT and GetDistance2SpawnPosition() > 1000):
				return
			SetAttackTarget(player)

func AI_ATTACK(delta):
	match AttackType:
		0:
			if(GetDistance2SpawnPosition() > 1100):
				Retreat()
			if(Global.GetDistance2Player(self) <= AttackRange):
				pass
			
func AI_RETREAT(delta):
	if(global_position.distance_to(spawn_position) <= rand_range(25, 55)):
		current_state = AI_states.IDLE
		
func check_player_in_detection() -> bool:
	var collider = LineOfSight.get_collider()
	if collider and collider.is_in_group("Players"):
		player_spotted = true
		return true
	return false
		
func GetDistance2ZoneParent():
	return global_position.distance_to(zoneParent.global_position)
	
func GetDistance2SpawnPosition():
	return global_position.distance_to(spawn_position)

func SetAttackTarget(thevictim):
	target = thevictim
	generate_path_to_node(target)
	current_state = AI_states.ATTACK
	
func BecomeIdle():
	target = null
	current_state = AI_states.IDLE
	
func Retreat():
	target = null
	generate_path_to_vector2(spawn_position)
	navigate()
	current_state = AI_states.RETREAT

func _on_DetectionZone_body_exited(body):
	if(target == body):
		moveDir = Vector2.ZERO
		BecomeIdle()
	if(GetDistance2SpawnPosition() > 1000):
		Retreat()
