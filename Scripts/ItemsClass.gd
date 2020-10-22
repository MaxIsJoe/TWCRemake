extends Area2D

export(String) var ItemName = "Item"
export(String) var ItemID = "misc-000"


func _on_Item_body_entered(body):
	if(body.is_in_group("Players")):
		body.grab(ItemID)
		queue_free()
		##This will be changed later, the player should grab the item when they're close to it using a hotkey or the classic drop down menu, but for now we'll work this this.##
