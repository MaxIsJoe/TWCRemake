extends Node2D

export(String) var SignName
export(String, MULTILINE) var SignContent
export(float) var InteractionDistance = 120




func _on_Control_gui_input(event):
	var distance2player = Global.GetDistance2Player(self)
	if(distance2player <= InteractionDistance):
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT and event.pressed:
				Data.Player.ShowSign(SignName,SignContent)
		if(Input.is_action_just_pressed("Interact")):
			Data.Player.ShowSign(SignName,SignContent)
