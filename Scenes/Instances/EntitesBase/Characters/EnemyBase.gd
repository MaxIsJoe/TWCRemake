extends "res://Scenes/Instances/EntitesBase/Characters/CharacterEntity.gd"

export(int) var SpawnerID: int = 0
export(int, "Melee", "Caster") var AttackType = 0
export(float) var AttackRange = 35
export(float, 0.0, 4.0) var AttackRangeLerpTime = 0.7
export(float) var AttackCooldown = 1.0
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
var ourname

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
	if(get_tree().get_network_unique_id() == 1):
		LookAtTarget()
		match current_state:
			AI_states.IDLE:
				AI_IDLE()
			AI_states.ATTACK:
				AI_ATTACK(delta)
			AI_states.RETREAT:
				AI_RETREAT(delta)
			

func GetEntityData():
	var data = {
		"pid": SpawnerID,
		"id": name,
		"P": global_position, 
		"A": SpriteHandler.currentDir, 
	}
	return data
	
	
func UpdateEntityData(data):
	global_position = lerp(global_position, data[ourname]["P"], 0.4)
	SpriteHandler.currentDir = data[ourname]["A"]
	
	SpriteHandler.PlayDirectionalAnimAll(SpriteHandler.currentDir)

func AI_IDLE():
	SeekPlayer()

func AI_ATTACK(delta):
	match AttackType:
		0:
			CheckIfTargetIsAlive()
			if(GetDistance2SpawnPosition() > 1100):
				Retreat()
			if(target.global_position.distance_to(self.global_position) <= AttackRange):
				MeleeAttackLogic(target)
			
func AI_RETREAT(delta):
	if(global_position.distance_to(spawn_position) <= rand_range(0,75)):
		BecomeIdle()
		
func check_player_in_detection() -> bool:
	var collider = LineOfSight.get_collider()
	if collider and collider.is_in_group("Players"):
		player_spotted = true
		return true
	return false

func CheckIfTargetIsAlive():
	if(target.health.currentState == health.HealthState.DEAD):
		Retreat()
		
func MeleeAttackLogic(victim):
	if(victim != null): #This is to prevent a bug where the game checks for a victim when they have already died or left
		if(victim.is_in_group("Players")):
			if(canAttack):
				victim.rpc("takedamage", stats.damage)
				canAttack = false
				$AttackCooldown.start()
		
func SeekPlayer():
	if(current_state == AI_states.IDLE or current_state == AI_states.SEARCH or current_state == AI_states.WANDER):
		var player = GetNearestPlayer()
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
	rpc_id(0, "SyncTarget", thevictim)
	generate_path_to_node(target)
	current_state = AI_states.ATTACK
	LineOfSight.cast_to.x = LineOfSight.cast_to.x + AlertExtraRange
	$ChaseTimeout.start()
	
func BecomeIdle():
	stop_navigating()
	target = null
	rpc_id(0, "SyncTarget", target)
	current_state = AI_states.IDLE
	LineOfSight.cast_to.x = default_raycast_range
	
func Retreat():
	target = null
	rpc_id(0, "SyncTarget", target)
	player_spotted = false
	generate_path_to_vector2(spawn_position)
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
			if(current_state == AI_states.IDLE or current_state == AI_states.ATTACK or current_state == AI_states.WANDER):
				Retreat()
			else:
				BecomeIdle()
	else:
		$ChaseTimeout.start()

func GetNearestPlayer():
	var nearest_player = null
	for player in NetworkManager.PlayerContainer.get_children():
		if(nearest_player == null):
			nearest_player = player
		if(player.global_position.distance_to(self.global_position) > nearest_player.global_position.distance_to(player.global_position)):
			nearest_player = player
	return nearest_player

remotesync func SyncTarget(t):
	target = t

func _on_AttackCooldown_timeout():
	canAttack = true


func _on_DetectionZone_body_entered(body):
	if(body.is_in_group("Players") and current_state != AI_states.ATTACK):
		$LineOfSight/LoSTween.interpolate_property(LineOfSight, "cast_to:x", LineOfSight.cast_to.x, LineOfSight.cast_to.x + AlertExtraRange, AttackRangeLerpTime, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$LineOfSight/LoSTween.start()



func _on_DetectionZone_body_exited(body):
	if(body.is_in_group("Players") and current_state != AI_states.ATTACK):
		$LineOfSight/LoSTween.interpolate_property(LineOfSight, "cast_to:x", LineOfSight.cast_to.x, default_raycast_range, AttackRangeLerpTime, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$LineOfSight/LoSTween.start()
