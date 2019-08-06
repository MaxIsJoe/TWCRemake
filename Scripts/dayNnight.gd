extends Node

var Day = false
var Night = true
var timer
var WaitForNextTimeOfDay = 420 #7 minutes
var NightColor = Color(7, 33,203,71)
var DayColor = Color(7, 33, 203, 0)


func _ready():
	timer = Timer.new() #Create a new timer to track how long until we change in-game times
	timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(timer)
	timer.wait_time = WaitForNextTimeOfDay
	timer.one_shot = false
	timer.start() #Godot *should* keep track of time globaly and not just one scene

func _on_timer_timeout():
   TimeMove()
   #print("Ding!")

func TimeMove():
	if(Day == true):
		Night = true
		Day = false
		print(Day, Night)
	elif(Night == true):
		Day = true
		Night = false
		print(Day, Night)

func ChangeToDay(ColorRectNode):
	ColorRectNode.Color = NightColor
func ChangeToNight(ColorRectNode):
	ColorRectNode.Color = DayColor
