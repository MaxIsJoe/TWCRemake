extends Node2D

var pl
var spawnpos


func Move_To_Scene(nextscene, player,spawnPos):
	call_deferred("Deffered_MoveToScene", nextscene, player,spawnPos)
	#Deffered_MoveToScene(nextscene, player,spawnPos)
	
func Deffered_MoveToScene(nextscene, player,spawnPos):
	var scene = nextscene
	pl = player
	print("Chaning Scene..")
	player.get_parent().remove_child(player)
	get_tree().get_root().add_child(pl)
	get_tree().change_scene(nextscene) #<--- Stops here
	print("change_scene test print")
	get_tree().get_root().add_child(player) #<-- Player doesn't get added
	print("we reached this point") #<--- Doesn't get printed
	player.position = spawnPos
