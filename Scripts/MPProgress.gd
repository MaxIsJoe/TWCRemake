extends TextureProgressBar

func _on_Player_mpupdate(mana, mana_max):
	max_value = mana_max
	$Tween.interpolate_property(self, "value",
		value, mana, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
