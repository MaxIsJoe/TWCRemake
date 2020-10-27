extends Button

var ID

func UpdateButtionUI(img):
	$TextureRect.texture = load(img)


func _on_RadialButton_button_down():
	match $TextureRect.texture.resource_path:
		Data.UI_Icon_Grab:
			Data.Player.grab(ID)
			get_parent().get_parent().get_parent().queue_free()
