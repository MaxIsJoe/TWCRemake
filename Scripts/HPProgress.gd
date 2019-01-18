extends TextureProgress

onready var tween = $Tween

func _on_Player_hpupdate(health):
	#value = health
	tween.interpolate_property(self, "value",
        value, health, 1,
        Tween.EASE_OUT , Tween.EASE_IN_OUT)
	tween.start()

