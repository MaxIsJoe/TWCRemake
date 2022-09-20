extends Area2D

@export var ItemName: String = "Item"
@export var ItemID: String = "misc-000"
@export var InteractionDistance: float = 69

@onready var radialmenu = $RadialMenu

func _ready():
	$RadialMenu.LoadButton("Grab", ItemID)


func _on_Item_input_event(viewport, event, shape_idx):
	var distance2player = Global.GetDistance2Player(self)
	if(distance2player <= InteractionDistance):
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
				$RadialMenu.ToggleButtonVisbility(true)
				print("it's working")
