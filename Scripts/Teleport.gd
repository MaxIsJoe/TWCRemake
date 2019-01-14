extends Node2D

func Move_To_Scene(nextscene, player):
	var scene = nextscene.instance()
	remove_child(player)
	get_tree().change_scene_to(scene)
	scene.add_child(player)