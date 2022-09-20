extends "res://Scenes/Instances/EntitesBase/Characters/CharacterEntity.gd"
class_name Enemy_Entity

@export var EnemyName: String = "Enemy"
@export var SpawnerID: int = 0 # This is used to allow the game to spawn entities for players who latejoin. can be used for other stuff later
@export var AttackType = 0 # What type of logic does this entity use for attacking? # (int, "Melee", "Caster")
@export var AttackRange = 45 # How far can they be before they can harm the player? # (float, 45, 500)
@export var AttackRangeLerpTime = 0.7 # When the player is inside their detection area, how fast does the entity's detection raycast get extended? # (float, 0.0, 4.0)
@export var AttackCooldown: float = 1.0 # Their attack rate
@export var AlertExtraRange: float = 35 # How long is their alert range when a player is in their detection area?
@export var IsLegendary: bool = false # Does this entity spawn as a legendary?
@export var AI_CanWander: bool = true # Is this entity allowed to wander around?
@export var AI_WanderTime: int = 450 # How long until this entity can wander again?
@export var AI_UsesNavMeshForWander: bool = true # Does this entity use nav_mesh to wander around?
@export var AI_HasNoLimitsOutsideOfSpawn: bool= false # Can This enitity leave it's spawn area?
@export var AI_MaxDistanceAwayFromSpawn: float = 1000 # How far is this entity allowed to go before retreating to where it spawned?
@export var AttackSounds : Array # (Array, AudioStream)
@export var AlertSounds  : Array # (Array, AudioStream)


@onready var AttackSoundPlayer = $Audio/Attack
@onready var AlertSoundPlayer = $Audio/Alerts

var zoneParent

var spawn_position        : Vector2
var wander_position       : Vector2
var default_raycast_range : float

var target
var current_state          = AI_states.IDLE
var player_spotted  : bool = false
var canAttack       : bool = true
var ourname

enum AI_states {
	IDLE,
	WANDER,
	SEARCH,
	ATTACK,
	RETREAT
}


func _ready():
	LineOfSight.enabled = true
	default_raycast_range = LineOfSight.cast_to.x
	$AttackCooldown.wait_time = AttackCooldown

func _physics_process(delta):
	#Only allow the server to host logic for entites.
	#Path3D finding can be expensive sometimes so it's best for the server to handle it.
	#Plus this avoids some syncing issues where the entity does something other players can't see.
	if(get_tree().get_unique_id() == 1):
		if(OptimizationCheck_PlayersNearby()):
			LookAtTarget()
			match current_state:
				AI_states.IDLE:
					AI_IDLE()
				AI_states.ATTACK:
					AI_ATTACK(delta)
				AI_states.RETREAT:
					AI_RETREAT(delta)
				AI_states.WANDER:
					AI_WANDER(delta)
			

func GetEntityData():
	#we need to find a way to make this list shorter to save checked bytes
	var data = {
		"pid": SpawnerID,
		"id": name,
		"P": global_position, 
		"A": SpriteHandler.currentDir, 
		"R": rotation_degrees, 
	}
	return data
	
	
func UpdateEntityData(data):
	global_position = lerp(global_position, data[ourname]["P"], 0.4)
	SpriteHandler.currentDir = data[ourname]["A"]
	rotation_degrees = data[ourname]["R"]
	
	SpriteHandler.PlayDirectionalAnimAll(SpriteHandler.currentDir)

func AI_IDLE():
	SeekPlayer()

func AI_ATTACK(delta):
	match AttackType:
		0:
			if(target != null): #For some reason the game will still run AI_ATTACK() when moving to other phases
				if(CheckIfTargetIsAlive() == false):
					if(GetDistance2SpawnPosition() > 1100):
						Retreat()
					if(target.global_position.distance_to(self.global_position) <= AttackRange):
						MeleeAttackLogic(target)
			
func AI_RETREAT(delta):
	if(global_position.distance_to(spawn_position) <= randf_range(5,75)):
		Retreat()
		
func AI_WANDER(delta):
	SeekPlayer()
	randomize()
	if(wander_position == Vector2.ZERO or wander_position == null):
		wander_position = GetRandomWanderPosition()
	match AI_UsesNavMeshForWander:
		true:
			if(nav_path == []):
				generate_path_to_vector2(wander_position)
		false:
			var direction = (wander_position - global_position).normalized()
			moveDir = moveDir.move_toward(direction * stats.movement_speed, 300 * delta)
	if(global_position.distance_to(wander_position) <= randf_range(0.25, 3.25)):
		BecomeIdle()
	if(GetDistance2SpawnPosition() >= AI_MaxDistanceAwayFromSpawn):
		Retreat()
	
func GetRandomWanderPosition():
	randomize()
	var random_direction = Vector2.RIGHT.rotated(randf() * TAU)
	var random_postion = random_direction * $DetectionZone/CollisionShape2D.shape.radius * randf_range(0, 1.0)
	return global_position + random_postion
	
		
func check_player_in_detection() -> bool:
	var collider = LineOfSight.get_collider()
	if collider and collider.is_in_group("Players"):
		player_spotted = true
		return true
	return false

func CheckIfTargetIsAlive():
	if(target.health.currentState == health.HealthState.DEAD):
		Retreat()
		return true
	else:
		return false
		
func MeleeAttackLogic(victim):
	if(victim != null): #This is to prevent a bug where the game checks for a victim when they have already died or left
		if(canAttack):
			if(victim.is_in_group("Players")):
				victim.rpc("takedamage", stats.damage, self)
				canAttack = false
				$AttackCooldown.start()
			if(victim.is_in_group("enemy")):
				victim.health.TakeDamage(stats.damage, self)
			rpc_id(0, "PlayAttackSounds")
		
func SeekPlayer():
	if(current_state == AI_states.IDLE or current_state == AI_states.SEARCH or current_state == AI_states.WANDER):
		var player = GetNearestPlayer()
		if(player != null):
			LineOfSight.look_at(player.global_position)
			if(check_player_in_detection() == true):
				if(current_state == AI_states.RETREAT and GetDistance2SpawnPosition() > AI_MaxDistanceAwayFromSpawn):
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
	rpc_id(0, "PlayAlertSounds")
	
func BecomeIdle():
	$RefreshNav.stop()
	wander_position = Vector2.ZERO
	moveDir = Vector2(0,0)
	target = null
	#rpc_id(0, "SyncTarget", target)
	current_state = AI_states.IDLE
	LineOfSight.cast_to.x = default_raycast_range
	rpc_id(0, "PlayAlertSounds")
	
func StartWandering():
	stop_navigating()
	$RefreshNav.stop()
	current_state = AI_states.WANDER
	$WanderCooldown.start()

func Retreat():
	stop_navigating()
	$RefreshNav.stop()
	wander_position = Vector2.ZERO
	#rpc_id(0, "SyncTarget", target)
	target = null
	player_spotted = false
	generate_path_to_vector2(spawn_position)
	current_state = AI_states.RETREAT
	rpc_id(0, "PlayAlertSounds")

func LookAtTarget():
	if(target != null):
		LineOfSight.look_at(target.global_position)

func _on_RefreshNav_timeout():
	if(player_spotted and target != null):
		generate_path_to_node(target)
	else:
		StartWandering()


func _on_ChaseTimeout_timeout():
	if(check_player_in_detection() == false):
		target = null
		if(GetDistance2SpawnPosition() > AI_MaxDistanceAwayFromSpawn):
			if(current_state == AI_states.IDLE or current_state == AI_states.ATTACK or current_state == AI_states.WANDER):
				Retreat()
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

@rpc(any_peer, call_local) func SyncTarget(t):
	target = t

func _on_AttackCooldown_timeout():
	canAttack = true

@rpc(any_peer, call_local) func PlayAttackSounds():
	if(AttackSounds.size() != 0):
		randomize()
		var sound_to_play = AttackSounds[int(randf_range(0, AttackSounds.size() - 1))]
		audio_setTrack(AttackSoundPlayer, sound_to_play)
		audio_playCurrentTrack(AttackSoundPlayer, true)

@rpc(any_peer, call_local) func PlayAlertSounds():
	if(AlertSounds.size() != 0):
		randomize()
		var sound_to_play = AlertSounds[int(randf_range(0, AttackSounds.size() - 1))]
		audio_setTrack(AlertSoundPlayer, sound_to_play)
		audio_playCurrentTrack(AlertSoundPlayer, true)

func _on_DetectionZone_body_entered(body):
	if(body.is_in_group("Players") and current_state != AI_states.ATTACK):
		$LineOfSight/LoSTween.interpolate_property(LineOfSight, "cast_to:x", LineOfSight.cast_to.x, LineOfSight.cast_to.x + AlertExtraRange, AttackRangeLerpTime, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$LineOfSight/LoSTween.start()



func _on_DetectionZone_body_exited(body):
	if(body.is_in_group("Players") and current_state != AI_states.ATTACK):
		$LineOfSight/LoSTween.interpolate_property(LineOfSight, "cast_to:x", LineOfSight.cast_to.x, default_raycast_range, AttackRangeLerpTime, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$LineOfSight/LoSTween.start()
	if(body == target and $RefreshNav.is_stopped() and current_state == AI_states.ATTACK):
		_on_RefreshNav_timeout()
		$RefreshNav.start()
	if(target == null and current_state == AI_states.ATTACK):
		stop_navigating()
		Retreat()


func _on_WanderCooldown_timeout():
	if(AI_CanWander):
		if(current_state == AI_states.IDLE):
			StartWandering()

func OptimizationCheck_PlayersNearby():
	var closest_player
	for player in NetworkManager.PlayerContainer.get_children():
		if(closest_player == null):
			closest_player = player
		if(player.global_position.distance_to(self.global_position) > closest_player.global_position.distance_to(player.global_position)):
			closest_player = player
	if(closest_player.global_position.distance_to(self.global_position) <= 1750):
		return true
	else:
		return false
