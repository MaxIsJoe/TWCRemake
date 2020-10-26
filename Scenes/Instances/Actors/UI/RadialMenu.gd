extends Control

onready var RadialButton = load("res://Scenes/Instances/Actors/UI/buttons/RadialButton.tscn")

func LoadButton(Type, ID):
	var NewButton = RadialButton.instance()
	match Type:
		"Shop":
			NewButton.UpdateButtionUI(Data.UI_Icon_Shop)
		"Dialouge":
			NewButton.UpdateButtionUI(Data.UI_Icon_Dia)
		"Grab":
			NewButton.UpdateButtionUI(Data.UI_Icon_Grab)
	$CircularContainer.add_child(NewButton)
		
func ToggleButtonVisbility(Check:bool):
	if(Check): $AnimationPlayer.play("ShowButtons")
	else: $AnimationPlayer.play_backwards("ShowButtons")
