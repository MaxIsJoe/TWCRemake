extends Node

##This holds all the shop can sell and what is their ID

export(int) var ShopID = 0
export(Array, String) var ItemIDs : Array

func _ready():
	Data.Update_Group_ShopHolders()

func AddItemToShop(item: String):
	ItemIDs.append(item)
	
func RemoveItemFromShop(item: String):
	if(ItemIDs.has(item)):
		ItemIDs.erase(item)
	else:
		print("[Shop] - No such item found to remove.")
