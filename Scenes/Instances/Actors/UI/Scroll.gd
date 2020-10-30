extends Control

onready var txtField = $Scroll_Background/TextEdit

var ID

func LoadText(txt, loaded_ID):
	txtField.text = txt
	ID =  loaded_ID

func _input(event):
	if(Input.is_action_just_pressed("ui_cancel")):
		if(visible):
			var file = File.new()
			print("Savening scroll : " + str(ID))
			file.open("res://debug/Scrolls/" + str(ID) + ".txt", File.WRITE)
			file.store_string(txtField.text)
			file.close()
			visible = false
			if(txtField.text != ""):
				var buttons = get_tree().get_nodes_in_group("ItemButtons")
				for button in buttons:
					if(button.ScrollID == ID):
						button.ItemIcon.texture = load("res://Sprites/TWCSpritesCoverted/items/scroll_written.png")
			txtField.text = ""

func _on_TextEdit_text_changed():
	if("[sign]" in txtField.text):
		var newtext = txtField.text.replace("[sign]", Data.Player.PlayerName)
		txtField.text = newtext
