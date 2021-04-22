extends CanvasModulate

export(float) var ShortDuration = 6
export(float) var LongDuration = 12
export(Color) var DayColor
export(Color) var NightColor
export(Color) var DawnColor
export(Color) var MidnightColor
export(Color) var BloodMoon


enum TimeOfDay  {
	Day,
	Dusk,
	Dawn,
	Night,
	Midnight	
}

#How long do days/nights take?
#(Max) : Values are too low for now for testing. Night and day times should be longer on release
var TimeLong  : float = 120
var TimeShort : float = 60

sync var currentTime = TimeOfDay.Day

var timer

var allowOldSystem : bool = false

func StartCycle():
	timer = Timer.new()
	timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(timer)
	timer.wait_time = TimeShort
	timer.one_shot = false
	timer.start()
	print_debug("[WORLD] : Day And Night is ready!")
	print_debug("[WORLD] : Timer wait_time = " + str(timer.wait_time))


remote func ChangeColor(color):
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

func ChangeTime(Time):
	if(get_network_master() == 1):
		match Time:
			TimeOfDay.Day:
				rpc_id(0,"ChangeColor", "Day")
				rset_id(0, "currentTime", "TimeOfDay.Day")
			TimeOfDay.Dusk:
				rpc_id(0,"ChangeColor", "Dawn")
				rset_id(0, "currentTime", "TimeOfDay.Dusk")
			TimeOfDay.Night:
				rpc_id(0,"ChangeColor", "Night")
				rset_id(0, "currentTime", "TimeOfDay.Night")
			TimeOfDay.Midnight:
				rpc_id(0,"ChangeColor", "Midnight")
				rset_id(0, "currentTime", "TimeOfDay.Midnight")
			TimeOfDay.Dawn:
				rpc_id(0,"ChangeColor", "Dawn")
				rset_id(0, "currentTime", "TimeOfDay.Dawn")

func _on_timer_timeout():
	match currentTime:
		TimeOfDay.Day:
			ChangeTime(TimeOfDay.Dusk)
			timer.wait_time = TimeShort
		TimeOfDay.Night:
			ChangeTime(TimeOfDay.Midnight)
			timer.wait_time = TimeLong
		TimeOfDay.Midnight:
			ChangeTime(TimeOfDay.Dawn)
			timer.wait_time = TimeShort
		TimeOfDay.Dusk:
			ChangeTime(TimeOfDay.Night)
			timer.wait_time = TimeLong
		TimeOfDay.Dawn:
			ChangeTime(TimeOfDay.Day)
			timer.wait_time = TimeLong
