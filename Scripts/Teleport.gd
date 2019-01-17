extends Node2D

var current_scene = null
var pl
var spawnpos


func Move_To_Scene(thisscene,nextscene, player,spawnPos):
	call_deferred("Deffered_MoveToScene", thisscene,nextscene, player,spawnPos)
	
func Deffered_MoveToScene(thisscene,nextscene, player,spawnPos):
	var scene = nextscene
	pl = player
	spawnpos = spawnPos
	thisscene.remove_child(player)
	remove_child(player)
	get_tree().change_scene(scene)
	#var newscene = get_tree().current_scene
	get_tree().get_root().add_child(player)
	player.position = spawnPos