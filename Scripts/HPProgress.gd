extends TextureProgress

func _on_Player_hpupdate(health, max_health):
	max_value = max_health
	$Tween.interpolate_property(self, "value",
		value, health, 1,
		Tween.EASE_OUT , Tween.EASE_IN_OUT)
	$Tween.start()

