extends Node

var ItemsArray = []
onready var InvUI = $InventoryUI

func has(item):
	return true if find_item(item) else false

func use(item, player):
	item.use(player)

func grab(item):
	ItemsArray.append(item)

func update_inventory():
	for Item in ItemsArray:
		#print(ItemsArray.size())
		InvUI.create_item_button(Item)