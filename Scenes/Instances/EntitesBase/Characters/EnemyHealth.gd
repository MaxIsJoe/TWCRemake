extends Entity_Health

export(NodePath) var enemyBasePath

var EnemeyBase : Enemy_Entity

func _ready():
	EnemeyBase = get_node(enemyBasePath)

remotesync func TakeDamage(damage: int, damagedBy):
	.TakeDamage(damage, damagedBy)
	if(EnemeyBase.current_state == EnemeyBase.AI_states.IDLE or 
	EnemeyBase.current_state == EnemeyBase.AI_states.RETREAT or 
	EnemeyBase.current_state == EnemeyBase.AI_states.WANDER):
		if(damagedBy is PlayerEntity):
			EnemeyBase.SetAttackTarget(damagedBy)
