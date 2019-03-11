extends Area2D
export (bool) var IsImportant
export (bool) var CanBeThrown
export (bool) var CanEquip
export (int) var VALUE
export (String) var NAME
export (String) var DESC
export (Image) var ICON

var picked = false

func _on_Item_body_entered(body):
	if(body.is_in_group("Players")):
		#body.get_node("Inventory").ItemsArray.append(self)
		body.grab(self)
		#body.update_inventory()
		queue_free()
	else:
		print("false")

func Equip():
	pass
