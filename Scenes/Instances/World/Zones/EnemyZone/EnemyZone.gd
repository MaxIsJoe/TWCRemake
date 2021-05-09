extends "res://Scenes/Instances/World/Zones/ZoneBase.gd"

export(int, 0, 100) var LegendaryEnemySpawnChance = 0
export(bool)        var CanLeaveZoneRadius        = false
export(bool)        var SpawnOnRadius             = true
export(Array, PackedScene) var EnemiesToSpawn : Array
export(Array, NodePath)    var SpawnLocations : Array

var SpawnerIsOnCooldown : bool = false


func _on_SpawnTimer_timeout():
	if(NetworkManager.PlayerContainer.get_child_count() != 0 and get_tree().get_network_unique_id() == 1):
		randomize()
		if(Entites.get_child_count() < max_entities and SpawnerIsOnCooldown == false):
			var enemyToSpawn = EnemiesToSpawn[int(rand_range(0, EnemiesToSpawn.size()))]
			var enemy = enemyToSpawn.instance()
			Entites.add_child(enemy)
			enemy.name = str(EntityIDs)
			enemy.zoneParent = self
			if(SpawnOnRadius):
				var random_direction = Vector2.RIGHT.rotated(randf() * TAU)
				var random_postion = random_direction * $CollisionShape2D.shape.radius * rand_range(0, 1.0)
				enemy.global_position = global_position + random_postion
				enemy.spawn_position = enemy.global_position
			else:
				enemy.global_position = SpawnLocations[int(rand_range(0, SpawnLocations.size()))].position
				enemy.spawn_position = enemy.global_position
			AddData(enemy.GetEnemyData())
			SpawnerIsOnCooldown = true


func _on_SpawnCooldown_timeout():
	SpawnerIsOnCooldown = false

func _on_ZoneBase_body_exited(body):
	._on_ZoneBase_body_exited(body)
	if(body.is_in_group("enemy")):
		body.current_state = 4
