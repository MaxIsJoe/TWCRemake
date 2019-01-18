extends TextureProgress

onready var tween = $Tween

func _on_Player_mpupdate(mana):
	#value = mana
	tween.interpolate_property(self, "value",
        value, mana, 1,
        Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
