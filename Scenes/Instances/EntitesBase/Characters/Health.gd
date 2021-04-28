extends Node

export(int) var HP = 100
export(int) var HP_MAX = 100
export(bool) var CanBeDamaged = false

var currentState = HealthState.ALIVE

enum HealthState {
	ALIVE,
	UNCONSCIOUS,
	DEAD
}


func _ready():
	if(get_tree().get_network_unique_id() != 1):
		SyncData(get_tree().get_network_unique_id())


func TakeDamage(damage: int):
	if(CanBeDamaged):
		HP -= damage
		if(HP <= 0):
			BecomeAlivent()

func Heal(HealType: int, points_to_heal: int):
	match(HealType):
		0: #Instant Heal
			HP += points_to_heal
			if(HP > HP_MAX):
				HP = HP_MAX
		1: #Heal over time
			pass #add later
	
func BecomeAlive():
	currentState = HealthState.ALIVE
	HP = HP_MAX

func BecomeAlivent():
	currentState = HealthState.DEAD
	
func SyncData(PlayerID: int):
	rset_id(PlayerID, "HP", HP)
	rset_id(PlayerID, "HP_MAX", HP_MAX)
	rset_id(PlayerID, "currentState", currentState)
	rset_id(PlayerID, "CanBeDamaged", CanBeDamaged)
