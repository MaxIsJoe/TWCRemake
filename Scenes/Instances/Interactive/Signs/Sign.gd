extends Node2D

@export var SignName: String
@export var SignContent # (String, MULTILINE)
@export var InteractionDistance: float = 120




func _on_Control_gui_input(event):
	var distance2player = Global.GetDistance2Player(self)
	if(distance2player <= InteractionDistance):
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				Data.Player.ShowSign(SignName,SignContent)
		if(Input.is_action_just_pressed("Interact")):
			Data.Player.ShowSign(SignName,SignContent)
