extends Control

signal remove_self(id)
signal update_self(id)

var ID

func UpdateData(PlayerName: String, PlayerYear: int, _PlayerHouse: int, PlayerID):
	$PlayerName.text = PlayerName
	$PlayerYear.text = str(PlayerYear)
	ID = PlayerID


func _on_OnlinePlayerInfo_remove_self(id):
	if(id == ID):
		queue_free()
