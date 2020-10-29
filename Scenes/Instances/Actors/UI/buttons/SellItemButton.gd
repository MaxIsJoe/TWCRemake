extends TextureButton


var price = 0
var ID

func LoadData(item):
	$ItemIcon.texture = load(Data.ItemData[item].get("icon"))
	$RichTextLabel.bbcode_text = Data.ItemData[item].get("name")
	price = Data.ItemData[item].get("baseprice")
	hint_tooltip = str(Data.ItemData[item].get("desc") + "\n \n" + "Price : " + str(price))
	ID = item


func _on_SellItemButton_button_down():
	if(Data.Player.gold >= price):
		Data.Player.gold -= price
		Data.Player.grab(ID)
	else:
		print("Not enough gold")
