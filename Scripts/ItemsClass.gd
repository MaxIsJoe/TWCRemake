extends Area2D
export (bool) var IsImportant
export (bool) var CanBeThrown
export (bool) var CanEquip
export (int) var value
export (String) var Name
export (String) var desc
export (Image) var Icon

func _on_Item_body_entered(body):
	if(body.has_node("Inventory")):
		#body.get_node("Inventory").ItemsArray.append(self)
		body.get_node("Inventory").grab(self)
		body.get_node("Inventory").update_inventory()
		queue_free()
	else:
		print("false")

func Equip():
	pass