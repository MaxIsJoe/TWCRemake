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

var currentTime = TimeOfDay.Day

var timer

var allowOldSystem : bool = false

func _ready():
	timer = Timer.new()
	timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(timer)
	timer.wait_time = TimeShort
	timer.one_shot = false
	timer.start()
	print_debug("[WORLD] : Day And Night is ready!")
	print_debug("[WORLD] : Timer wait_time = " + str(timer.wait_time))
	
func OLD_UpdateAllNodes(Time):
	if(allowOldSystem):
		var DNN_Nodes = get_tree().get_nodes_in_group("DNN")
		for node in DNN_Nodes:
			node.ChangeColor(Time)
		print_debug("[DayAndNight/warning] - Deprycated system that will be removed in the future has been called, please remove any traces of the old system.")
	else:
		print_debug("[DayAndNight/warning] - Deprycated system called while functionality is disabled.")

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

func ChangeTime(Time):
	match Time:
		TimeOfDay.Day:
			OLD_UpdateAllNodes("Day")
			ChangeColor("Day")
			currentTime = TimeOfDay.Day
		TimeOfDay.Dusk:
			OLD_UpdateAllNodes("Dawn")
			ChangeColor("Dawn")
			currentTime = TimeOfDay.Dusk
		TimeOfDay.Night:
			OLD_UpdateAllNodes("Night")
			ChangeColor("Night")
			currentTime = TimeOfDay.Night
		TimeOfDay.Midnight:
			OLD_UpdateAllNodes("Midnight")
			ChangeColor("Midnight")
			currentTime = TimeOfDay.Midnight
		TimeOfDay.Dawn:
			OLD_UpdateAllNodes("Dawn")
			ChangeColor("Dawn")
			currentTime = TimeOfDay.Dawn

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
