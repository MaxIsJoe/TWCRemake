extends Control

@onready var RadialButton = load("res://Scenes/Instances/Actors/UI/buttons/RadialButton.tscn")
var active = false


func _process(delta):
	if(active):
		var d2p = Global.GetDistance2Player(get_parent())
		#Has the player walked or teleported away from the menu?
		if(d2p >= get_parent().InteractionDistance):
			ToggleButtonVisbility(false)
		#Does he want to manually hide it?
		if(Input.is_key_pressed(KEY_ESCAPE)):
			ToggleButtonVisbility(false)

func LoadButton(Type, ID):
	var NewButton = RadialButton.instantiate()
	match Type:
		"Shop":
			NewButton.UpdateButtionUI(Data.UI_Icon_Shop)
		"Dialouge":
			NewButton.UpdateButtionUI(Data.UI_Icon_Dia)
		"Grab":
			NewButton.UpdateButtionUI(Data.UI_Icon_Grab)
	NewButton.ID = ID
	$CircularContainer.add_child(NewButton)
		
func ToggleButtonVisbility(Check:bool):
	if(Check): 
		$AnimationPlayer.play("ShowButtons"); active = true
	else: 
		$AnimationPlayer.play_backwards("ShowButtons"); active = false

