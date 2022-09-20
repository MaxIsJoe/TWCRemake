extends Button

@onready var ItemLabel = $ItemLabel
@onready var ItemIcon = $ItemIcon
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
	tooltip_text = Data.ItemData[ID].get("desc")


func _on_ItemButton_button_down():
	CheckForFunctions()

func CheckForFunctions():
	var Function = Data.ItemData[ID].get("Function")
	if(Function.begins_with("Eat")):
		UseItem.Eat(Function)
		queue_free()
	if(Function.begins_with("OpenScroll")):
		UseItem.OpenScroll(ScrollID)
