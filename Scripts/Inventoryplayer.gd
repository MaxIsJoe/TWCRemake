extends Node

var ItemsArray = []
var OnPlayer = []
@onready var InvUI = $InventoryUI

func has(item):
	return true if find_item(item) else false

func use(item, player):
	item.use(player)

func Equip(item):
	OnPlayer.append(item)

func grab(item):
	ItemsArray.append(item)

func update_inventory():
	for Item in ItemsArray:
		#print(ItemsArray.size())
		InvUI.create_item_button(Item)
