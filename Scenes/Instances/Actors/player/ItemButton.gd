extends Button

onready var ItemLabel = $ItemLabel
onready var ItemIcon = $ItemIcon
onready var ItemMenu = $MenuButton
var itemreferece

func UpdateButton(Name,Icon):
	ItemLabel.text = Name
	ItemIcon.texture = Icon
	#itemref = itemreferece
	print(name)

