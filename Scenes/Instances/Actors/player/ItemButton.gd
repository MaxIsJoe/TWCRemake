extends Button

onready var ItemLabel = $ItemLabel
onready var ItemIcon = $ItemIcon
var ID
var ButtonID = 0

#Special
var ScrollID = 0

func UpdateButton(ItemID, B_ID):
	ItemLabel.text = Data.ItemData[ItemID].get("name")
	ItemIcon.texture = load(Data.ItemData[ItemID].get("icon"))
	if(!Data.ItemData[ItemID].get("Useable")):
		if(!!Data.ItemData[ItemID].get("Equipable")):
			disabled = true
	if(Data.ItemData[ItemID].has("ScrollID")):
		if(Data.ItemData[ItemID].get("ScrollID") == null):
			ScrollID = UseItem.UpdateScrollIDs()
			print("new scroll ID = " + str(ScrollID))
		else:
			ScrollID = Data.ItemData[ItemID].get("ScrollID")
			ItemIcon.texture = load("res://Sprites/TWCSpritesCoverted/items/scroll_written.png")
	
	ID = ItemID
	ButtonID = B_ID


func _on_ItemButton_button_down():
	CheckForFunctions()

func CheckForFunctions():
	var Function = Data.ItemData[ID].get("Function")
	if(Function.begins_with("Eat")):
		UseItem.Eat(Function)
		queue_free()
	if(Function.begins_with("OpenScroll")):
		UseItem.OpenScroll(ScrollID)

func _on_ItemButton_mouse_entered():
	var p = get_tree().get_nodes_in_group("UI_ItemDescPanel")
	var v = get_tree().get_nodes_in_group("UI_ItemIconPanel")
	var a = get_tree().get_nodes_in_group("UI_ItemNamePanel")
	for d in p:
		d.bbcode_text = Data.ItemData[ID].get("desc")
	for d in v: #Noticed the joke? Yes.. I know, I'm unfunny.
		d.texture = load(Data.ItemData[ID].get("icon"))
	for d in a:
		d.text = Data.ItemData[ID].get("name")
