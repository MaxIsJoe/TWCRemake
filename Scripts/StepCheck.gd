extends Area2D

var BodiesOnTop = []

func _on_StepCheck_body_shape_entered(body_id, body, body_shape, area_shape):
	print(body.name)
	if(body.is_in_group("DNNInt")):
		BodiesOnTop.append(body)
		body.modulate = Color(0.14, 0.52, 0.88, 0.90)
		print("changed color")
		


func _on_StepCheck_body_shape_exited(body_id, body, body_shape, area_shape):
	if(body.is_in_group("DNNInt")):
		BodiesOnTop.erase(body)
		body.modulate = Color(1, 1, 1, 1)
		print("changed color")
		
func _process(delta):
	if(dayNnight.Day):
		for p in BodiesOnTop:
			p.modulate = Color(1, 1, 1, 1)
	if(dayNnight.Night):
		for p in BodiesOnTop:
			p.modulate = Color(0.14, 0.52, 0.88, 0.90)
