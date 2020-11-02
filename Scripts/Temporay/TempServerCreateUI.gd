extends Control


var PlayerName = ""


func _on_CreateServer_pressed():
	if PlayerName == "":
		return
	Network.CreateServer(PlayerName)
	_load_game()

func _on_JoinServer_pressed():
	if PlayerName == "":
		return
	Network.ConnectToServer(PlayerName)
	_load_game()
	
func _load_game():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")


func _on_TextEdit_text_changed(new_text):
	PlayerName = $TextEdit.text
	print(PlayerName)
