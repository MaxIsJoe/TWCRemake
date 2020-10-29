extends Node

export(int) var ShopID = 0
export(Array, String) var ItemIDs

func _ready():
	Data.Update_Group_ShopHolders()
