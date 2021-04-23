extends Area2D

var IsOpen = false


func _on_MovingStones_body_entered(body):
	if(body.is_in_group("Players") and IsOpen == false):
		IsOpen = true
		$Anim.play("open")
		$AudioStreamPlayer2D.play()
		$Timer.start()


func _on_Timer_timeout():
	if(get_overlapping_bodies().size() > 0):
		IsOpen = false
		$Anim.play_backwards("open")
		$AudioStreamPlayer2D.play()
