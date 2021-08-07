extends Entity_Health



remotesync func TakeDamage(damage: int, damagedBy):
	.TakeDamage(damage, damagedBy)
	if(parent.current_state == parent.AI_states.IDLE or 
	parent.current_state == parent.AI_states.RETREAT or 
	parent.current_state == parent.AI_states.WANDER):
		if(damagedBy is PlayerEntity):
			parent.SetAttackTarget(damagedBy)
