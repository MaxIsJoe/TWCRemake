extends Area2D

export(int) var max_entities: int = 25 # how many entites are allowed to spawn?

var PlayersInArea  : Array  = [] # how many players exist right now inside of this zone?
var CanSyncEntites : bool = false # do we sync EntitesState with everyone?

var EntitesState: Dictionary = {} # Entity data that needs to be synced
var EntityIDs    : int = 0

onready var Entites = $EntitesContanier


func _physics_process(delta):
	if(CanSyncEntites == true):
		if(get_tree().get_network_unique_id() == 1):
			rpc_unreliable_id(0, "SyncAllData")

remote func SyncAllData():
	if(get_tree().get_network_unique_id() != 1):
		for entity in Entites.get_children():
			if(EntitesState.has(str(entity.name))):
				entity.UpdateEnemyData(EntitesState)
			else:
				rpc_id(1, "SyncDataDictionary")
				LateSpawnEntity()
				
remote func LateSpawnEntity():
	for entity in EntitesState:
		if(Entites.has_node(str(EntitesState[entity[str(name)]]))):
			return
		else:
			var EntityToSpawn = load(Data.EntitesPath[entity["pid"]])
			EntityToSpawn.instance()
			EntityToSpawn.name = entity["id"]
			add_child(EntityToSpawn)
			EntityToSpawn.UpdateEnemyData(EntitesState)

remotesync func SyncDataDictionary():
	rset_id(0, "EntitesState", EntitesState)

func AddData(EntityData: Dictionary):
	EntitesState[EntityData.get("id")] = EntityData
	EntityIDs += 1
	
func RemoveData(EntityID):
	EntitesState.erase(EntityID)
	if($EntitesContanier.has_node(str(EntityID))):
		Entites.get_node(str(EntityID)).queue_free()
		
remotesync func RemoveAllEntites():
	EntitesState.empty()
	rset_id(0, "EntitesState", EntitesState)
	
	for entity in Entites.get_children():
		rpc_id(0, "RemoveEntity", entity)

remotesync func RemoveEntity(entity):
	if(Entites.has_node(entity)):
		entity.queue_free()

func _on_ZoneBase_body_entered(body):
	if(body.is_in_group("Players")):
		if(get_tree().get_network_unique_id() != 1):
			rpc_id(1, "AddPlayersInArea", body)
		else:
			AddPlayersInArea(body)

func _on_ZoneBase_body_exited(body):
	if(body.is_in_group("Players")):
		if(get_tree().get_network_unique_id() != 1):
			rpc_id(1, "RemoveFromPlayersInArea", body)
		else:
			RemoveFromPlayersInArea(body)

func GetNearestPlayerInZone():
	var nearest_player = null
	for player in PlayersInArea:
		if(nearest_player == null):
			nearest_player = player
		if(player.global_position.distance_to(self.global_position) > nearest_player.global_position.distance_to(player.global_position)):
			nearest_player = player
	return nearest_player

remote func AddPlayersInArea(player):
	PlayersInArea.append(player)
	CanSyncEntites = true
		
	
remote func RemoveFromPlayersInArea(player):
	PlayersInArea.erase(player)
	if(PlayersInArea.size() == 0):
		CanSyncEntites = false
