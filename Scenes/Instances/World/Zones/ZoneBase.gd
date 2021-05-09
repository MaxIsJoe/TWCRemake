extends Area2D

export(int) var max_entities: int = 25 # how many entites are allowed to spawn?

var PlayersInArea  : Array  = [] # how many players exist right now inside of this zone?
var CanSyncEntites : bool = false # do we sync EntitesState with everyone?

var EntitesState : Dictionary = {} # Entity data that needs to be synced
var EntityIDs    : int = 0

onready var Entites = $EntitesContanier


func _physics_process(delta):
	if(CanSyncEntites == true):
		if(get_tree().get_network_unique_id() == 1):
			for entity in Entites.get_children():
				if(EntitesState.has(entity.name)):
					EntitesState[entity.name] = entity.GetEntityData()
			rpc_unreliable_id(0, "SyncDataDictionary", EntitesState)
			rpc_unreliable_id(0, "SyncAllData")

remotesync func SyncAllData():
	if(!EntitesState.empty() and get_tree().get_network_unique_id() != 1):
		for entity in EntitesState:
			if(Entites.has_node(str(entity))):
				var entitynode = Entites.get_node(entity)
				entitynode.UpdateEntityData(EntitesState)
			else:
				LateSpawnEntity(entity)
				
func LateSpawnEntity(entity):
	var path = EntitesState[entity]["pid"]
	var Entityspawnid = load(Data.EntitesPath[path])
	var EntityToSpawn = Entityspawnid.instance()
	Entites.add_child(EntityToSpawn)
	EntityToSpawn.ourname = str(entity)
	EntityToSpawn.name = str(entity)
	EntityToSpawn.UpdateEntityData(EntitesState)

remotesync func SyncDataDictionary(data):
	EntitesState = data
	

func AddData(EntityData: Dictionary):
	EntitesState[EntityData.get("id")] = EntityData
	EntityIDs += 1
	rpc_id(0, "SyncDataDictionary", EntitesState)
	
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
