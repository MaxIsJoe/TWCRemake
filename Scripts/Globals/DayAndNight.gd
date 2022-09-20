extends CanvasModulate

@export var ShortDuration: float = 6
@export var LongDuration: float = 12
@export var DayColor: Color
@export var NightColor: Color
@export var DawnColor: Color
@export var MidnightColor: Color
@export var BloodMoon: Color


enum TimeOfDay  {
	Day,
	Dusk,
	Dawn,
	Night,
	Midnight	
}

#How long do days/nights take?
#(Max) : Values are too low for now for testing. Night and day times should be longer checked release
var TimeLong  : float = 120
var TimeShort : float = 60

var currentTime = TimeOfDay.Day

var timer

func StartCycle():
	timer = Timer.new()
	timer.connect("timeout",Callable(self,"_on_timer_timeout")) 
	add_child(timer)
	timer.wait_time = TimeShort
	timer.one_shot = false
	timer.start()
	print_debug("[WORLD] : Day And Night is ready!")
	print_debug("[WORLD] : Timer wait_time = " + str(timer.wait_time))


@rpc(any_peer) func ChangeColor(color):
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
	if(get_tree().get_unique_id() == 1):
		match Time:
			TimeOfDay.Day:
				rpc_id(0,"ChangeColor", "Day")
				ChangeColor("Day")
				currentTime = TimeOfDay.Day
				rpc_id(0, "SetCurrentTime", currentTime)
			TimeOfDay.Dusk:
				rpc_id(0,"ChangeColor", "Dawn")
				ChangeColor("Dawn")
				currentTime = TimeOfDay.Dusk
				rpc_id(0, "SetCurrentTime", currentTime)
			TimeOfDay.Night:
				rpc_id(0,"ChangeColor", "Night")
				ChangeColor("Night")
				currentTime = TimeOfDay.Night
				rpc_id(0, "SetCurrentTime", currentTime)
			TimeOfDay.Midnight:
				rpc_id(0,"ChangeColor", "Midnight")
				ChangeColor("Midnight")
				currentTime = TimeOfDay.Midnight
				rpc_id(0, "SetCurrentTime", currentTime)
			TimeOfDay.Dawn:
				rpc_id(0,"ChangeColor", "Dawn")
				ChangeColor("Dawn")
				currentTime = TimeOfDay.Dawn
				rpc_id(0, "SetCurrentTime", currentTime)
				
func SyncTime(playerID: int):
	if(playerID != 1):
		rpc_id(playerID, "SetCurrentTime", currentTime)
		rpc_id(playerID, "ChangeColor", currentTime)
		
@rpc(any_peer) func SetCurrentTime(time):
	currentTime = time

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
