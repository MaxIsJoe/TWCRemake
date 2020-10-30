extends Area2D

export(NodePath) var TeleportLocation


func _on_TeleportLocalNode_body_entered(body):
	if(body.is_in_group("Players")):
		body.position = get_node(TeleportLocation).position
