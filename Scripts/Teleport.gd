extends Node2D

var pl
var spawnpos


func Move_To_Scene(nextscene, player,spawnPos):
	#call_deferred("Deffered_MoveToScene", nextscene, player,spawnPos)
	Deffered_MoveToScene(nextscene, player,spawnPos)
	
func Deffered_MoveToScene(nextscene, player,spawnPos):
	var scene = nextscene
	pl = player
	print("Chaning Scene..")
	get_tree().change_scene(nextscene) #<--- Stops here
	get_tree().get_root().add_child(pl) #<-- Player doesn't get added
	print("we reached this point") #<--- Doesn't get printed
	player.position = spawnPos
