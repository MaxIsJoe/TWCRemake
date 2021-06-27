extends Control

onready var txtField = $Scroll_Background/TextEdit

var ID

func LoadText(txt, loaded_ID):
	txtField.text = txt
	ID =  loaded_ID

func _input(event):
	if(Input.is_action_just_pressed("ui_cancel")):
		if(visible):
			rpc_id(1, "ServerSaveScroll", txtField.text)
			txtField.text = ""
			visible = false

func _on_TextEdit_text_changed():
	if("[sign]" in txtField.text):
		var newtext = txtField.text.replace("[sign]", Data.Player.PlayerName)
		txtField.text = newtext

remotesync func ServerSaveScroll(txt):
	var file = File.new()
	print("Savening scroll : " + str(ID))
	file.open("res://debug/Scrolls/" + str(ID) + ".txt", File.WRITE)
	file.store_string(txt)
	file.close()
	#if(txtField.text != ""):
	#	var buttons = get_tree().get_nodes_in_group("ItemButtons")
	#	for button in buttons:
	#		if(button.ScrollID == ID):
	#			button.ItemIcon.texture = load("res://Sprites/TWCSpritesCoverted/items/scroll_written.png")
