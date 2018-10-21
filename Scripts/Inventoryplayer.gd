extends Node


func has(item):
	return true if find_item(item) else false

func use(item, player):
	item.use(player)
