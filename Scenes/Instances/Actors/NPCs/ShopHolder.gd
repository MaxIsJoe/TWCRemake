extends Node

##This holds all the shop can sell and what is their ID

@export var ShopID: int = 0
@export var ItemIDs : Array # (Array, String)

func _ready():
	Data.Update_Group_ShopHolders()

func AddItemToShop(item: String):
	ItemIDs.append(item)
	
func RemoveItemFromShop(item: String):
	if(ItemIDs.has(item)):
		ItemIDs.erase(item)
	else:
		print("[Shop] - No such item found to remove_at.")
