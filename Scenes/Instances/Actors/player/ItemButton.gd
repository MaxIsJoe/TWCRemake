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
	var p = get_tree().get_nodes_in_group("UI_ItemDescPanel")
	var v = get_tree().get_nodes_in_group("UI_ItemIconPanel")
	var a = get_tree().get_nodes_in_group("UI_ItemNamePanel")
	for d in p:
		d.bbcode_text = Data.ItemData[ID].get("desc")
	for d in v: #Noticed the joke? Yes.. I know, I'm unfunny.
		d.texture = load(Data.ItemData[ID].get("icon"))
	for d in a:
		d.text = Data.ItemData[ID].get("name")
