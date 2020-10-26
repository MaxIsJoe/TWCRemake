extends Area2D

export(String) var ItemName = "Item"
export(String) var ItemID = "misc-000"
export(float) var InteractionDistance = 69


func _ready():
	$RadialMenu.LoadButton("Grab", ItemID)

func GetDistanceToPlayer():
	var distance2player = self.global_position.distance_to(Data.Player.global_position)
	return distance2player

func _on_Item_body_entered(body):
	if(body.is_in_group("Players")):
		body.grab(ItemID)
		queue_free()
		##This will be changed later, the player should grab the item when they're close to it using a hotkey or the classic drop down menu, but for now we'll work this this.##


func _on_Item_input_event(viewport, event, shape_idx):
	var distance2player = GetDistanceToPlayer()
	if(distance2player <= InteractionDistance):
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_RIGHT and event.pressed:
				$RadialMenu.ToggleButtonVisbility(true)
				print("it's working")
