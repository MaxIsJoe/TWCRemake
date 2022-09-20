extends Button

var ID

func UpdateButtionUI(img):
	$TextureRect.texture = load(img)


func _on_RadialButton_button_down():
	#Handles what happens when clicking checked a button, not really the most ideal way of doing this but I have no better ideas so this is the way we're going to do stuff for now.
	match $TextureRect.texture.resource_path:
		Data.UI_Icon_Grab:
			Data.Player.grab(ID) #Used for picking items unchecked the ground
			get_parent().get_parent().get_parent().queue_free()
		Data.UI_Icon_Dia: #Used for starting dialouge, will always start at ID 000
			get_parent().get_parent().get_parent().Dialoug.StartDialouge("")
		Data.UI_Icon_Shop: #Load up a show
			Data.Player.ShowShopUI(get_parent().get_parent().get_parent().shop.ItemIDs, get_parent().get_parent().get_parent().shop.ShopID)
	get_parent().get_parent().ToggleButtonVisbility(false) #Hide after we interacted with you
