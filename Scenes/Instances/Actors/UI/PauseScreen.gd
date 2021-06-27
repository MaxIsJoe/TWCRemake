extends Control

var playerinfoUI = preload("res://Scenes/Instances/Actors/UI/OnlinePlayerInfo.tscn")

func AddPlayerToWhoScreen(id):
	var player = NetworkManager.Network.PlayerContainer.get_node(str(id))
	var ui = playerinfoUI.instance()
	ui.UpdateData(player.PlayerName, player.PlayerYear, int(id), id)
	$TabContainer/Main/WhoArea/VBoxContainer.add_child(ui)

func BuildPlayerWhoList():
	ClearPlayerWhoList()
	for player in NetworkManager.Network.PlayerContainer.get_children():
		AddPlayerToWhoScreen(player.name)

func ClearPlayerWhoList():
	for player in $TabContainer/Main/WhoArea/VBoxContainer.get_children():
		player.queue_free()


func _on_ForceSave_button_down():
	NetworkManager.Network.SavePlayer(get_tree().get_network_unique_id())
	
	
###Pages Stuff###
func PageSwitcher(page: int):
	match page:
		0:
			hideAllPages()
			$TabContainer/Settings/Pages/General.visible = true
		1:
			hideAllPages()
			$TabContainer/Settings/Pages/Visuals.visible = true
		2:
			hideAllPages()
			$TabContainer/Settings/Pages/DEBUG.visible = true
		3:
			hideAllPages()
			$TabContainer/Settings/Pages/About.visible = true
		4:
			hideAllPages()
			$TabContainer/Settings/Pages/Audio.visible = true

func hideAllPages():
	for page in $TabContainer/Settings/Pages.get_children():
		page.visible = false
		

func _on_General_pressed():
	PageSwitcher(0)
	
func _on_Visuals_pressed():
	PageSwitcher(1)

func _on_Audio_pressed():
	PageSwitcher(4)
	
func _on_Debugstuff_pressed():
	PageSwitcher(2)
	
func _on_About_pressed():
	PageSwitcher(3)


###DEBUG SECTION###

func _on_EnableDEBUGMode_toggled(button_pressed):
	Global.DEBUG_Mode = button_pressed
