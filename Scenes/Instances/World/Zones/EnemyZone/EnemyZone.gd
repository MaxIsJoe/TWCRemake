extends "res://Scenes/Instances/World3D/Zones/ZoneBase.gd"

@export var LegendaryEnemySpawnChance = 0 # (int, 0, 100)
@export var CanLeaveZoneRadius: bool        = false
@export var SpawnOnRadius: bool             = true
@export var EnemiesToSpawn : Array # (Array, PackedScene)
@export var SpawnLocations : Array # (Array, NodePath)

var SpawnerIsOnCooldown : bool = false


func _on_SpawnTimer_timeout():
	if(Global.PeacefulMode == false):
		if(NetworkManager.PlayerContainer.get_child_count() != 0 and get_tree().get_unique_id() == 1):
			randomize()
			if(Entites.get_child_count() < max_entities and SpawnerIsOnCooldown == false):
				var enemyToSpawn = EnemiesToSpawn[int(randf_range(0, EnemiesToSpawn.size()))]
				var enemy = enemyToSpawn.instantiate()
				Entites.add_child(enemy)
				enemy.name = str(EntityIDs)
				enemy.zoneParent = self
				if(SpawnOnRadius):
					var random_direction = Vector2.RIGHT.rotated(randf() * TAU)
					var random_postion = random_direction * $CollisionShape2D.shape.radius * randf_range(0, 1.0)
					enemy.global_position = global_position + random_postion
					enemy.spawn_position = enemy.global_position
				else:
					enemy.global_position = SpawnLocations[int(randf_range(0, SpawnLocations.size()))].position
					enemy.spawn_position = enemy.global_position
				AddData(enemy.GetEntityData())
				SpawnerIsOnCooldown = true


func _on_SpawnCooldown_timeout():
	SpawnerIsOnCooldown = false

func _on_ZoneBase_body_exited(body):
	super._on_ZoneBase_body_exited(body)
	if(body.is_in_group("enemy")):
		body.current_state = 4
