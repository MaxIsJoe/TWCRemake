extends Node

enum TimeOfDay  {
	Day,
	Dusk,
	Dawn,
	Night,
	Midnight	
}

var TimeLong = 120
var TimeShort = 60

var currentTime = TimeOfDay.Day

var timer


func _ready():
	timer = Timer.new()
	timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(timer)
	timer.wait_time = TimeShort
	timer.one_shot = false
	timer.start()
	print("[WORLD] : Day And Night is ready!")
	print("[WORLD] : Timer wait_time = " + str(timer.wait_time))
	
func UpdateAllNodes(Time):
	var DNN_Nodes = get_tree().get_nodes_in_group("DNN")
	for node in DNN_Nodes:
		node.ChangeColor(Time)

func ChangeTime(Time):
	match Time:
		TimeOfDay.Day:
			UpdateAllNodes("Day")
			currentTime = TimeOfDay.Day
		TimeOfDay.Dusk:
			UpdateAllNodes("Dawn")
			currentTime = TimeOfDay.Dusk
		TimeOfDay.Night:
			UpdateAllNodes("Night")
			currentTime = TimeOfDay.Night
		TimeOfDay.Midnight:
			UpdateAllNodes("Midnight")
			currentTime = TimeOfDay.Midnight
		TimeOfDay.Dawn:
			UpdateAllNodes("Dawn")
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
