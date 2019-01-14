extends Node2D

func Move_To_Scene(thisscene,nextscene, player,spawnPos):
	var scene = nextscene
	var PLAYER = player
	thisscene.remove_child(player)
	remove_child(PLAYER)
	get_tree().change_scene(scene)
	#call_deferred("add_player", PLAYER)
	add_child(PLAYER)
	PLAYER.position = spawnPos


func add_player(player):
	add_child(player)