extends ColorRect

export(float) var ShortDuration = 1
export(float) var LongDuration = 3
export(Color) var DayColor
export(Color) var NightColor
export(Color) var DawnColor
export(Color) var MidnightColor
export(Color) var BloodMoon

func _ready():
	match DayAndNight.TimeOfDay:
		DayAndNight.TimeOfDay.Day:
			color = DayColor
		DayAndNight.TimeOfDay.Night:
			color = NightColor
		DayAndNight.TimeOfDay.Midnight:
			color = MidnightColor
		DayAndNight.TimeOfDay.Dawn:
			color = DawnColor
		DayAndNight.TimeOfDay.Dusk:
			color = DawnColor

func ChangeColor(color):
	match color:
		"Day":
			$Tween.interpolate_property(self, "color", self.color, DayColor, ShortDuration,Tween.TRANS_CUBIC,Tween.EASE_IN_OUT)
			$Tween.start()
		"Night":
			$Tween.interpolate_property(self, "color", self.color, NightColor, LongDuration,Tween.TRANS_CUBIC,Tween.EASE_IN_OUT)
			$Tween.start()
		"Dawn":
			$Tween.interpolate_property(self, "color", self.color, DawnColor, LongDuration,Tween.TRANS_CUBIC,Tween.EASE_IN_OUT)
			$Tween.start()
		"Midnight":
			$Tween.interpolate_property(self, "color", self.color, MidnightColor, ShortDuration,Tween.TRANS_CUBIC,Tween.EASE_IN_OUT)
			$Tween.start()
		"Bloodmoon":
			$Tween.interpolate_property(self, "color", self.color, MidnightColor, ShortDuration,Tween.TRANS_BOUNCE,Tween.EASE_IN_OUT)
			$Tween.start()
