extends Button

onready var ItemLabel = $ItemLabel
onready var ItemIcon = $ItemIcon
var ID

func UpdateButton(ItemID):
	ItemLabel.text = Data.ItemData[ItemID].get("name")
	ItemIcon.texture = load(Data.ItemData[ItemID].get("icon"))
	if(!Data.ItemData[ItemID].get("Useable")):
		if(!!Data.ItemData[ItemID].get("Equipable")):
			disabled = true
	ID = ItemID



func _on_ItemButton_button_down():
	pass # Replace with function body.
