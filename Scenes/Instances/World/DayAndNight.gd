extends ColorRect

@export var ShortDuration: float = 1
@export var LongDuration: float = 3
@export var DayColor: Color
@export var NightColor: Color
@export var DawnColor: Color
@export var MidnightColor: Color
@export var BloodMoon: Color


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
