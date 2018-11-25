extends Button

onready var ItemLabel = $ItemLabel
onready var ItemIcon = $ItemIcon
onready var ItemMenu = $MenuButton
var itemreferece

func UpdateButton(Name,Icon,itemref):
	$ItemLabel.text = Name
	$ItemIcon.texture = Icon
	itemref = itemreferece
	print(name)

func _on_ItemButton_pressed():
	pass
	
