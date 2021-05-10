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
