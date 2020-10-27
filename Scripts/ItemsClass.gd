extends Area2D

export(String) var ItemName = "Item"
export(String) var ItemID = "misc-000"
export(float) var InteractionDistance = 69

onready var radialmenu = $RadialMenu

func _ready():
	$RadialMenu.LoadButton("Grab", ItemID)


func _on_Item_input_event(viewport, event, shape_idx):
	var distance2player = Global.GetDistance2Player(self)
	if(distance2player <= InteractionDistance):
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_RIGHT and event.pressed:
				$RadialMenu.ToggleButtonVisbility(true)
				print("it's working")
