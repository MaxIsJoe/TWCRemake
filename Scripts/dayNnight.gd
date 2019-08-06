extends Node

var Day = false
var Night = true
var timer
var WaitForNextTimeOfDay = 5 #420 #7 minutes
var NightColor = Color(0, 0.06, 0.45, 0.35)
var DayColor = Color(7, 33, 203, 0)

#signal ChangeToDay
#signal ChangeToNight

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
		#emit_signal("ChangeToNight")
	elif(Night == true):
		Day = true
		Night = false
		print(Day, Night)
		#emit_signal("ChangeToDay")

func _Change_ToNight():
	self.color = NightColor
	
func _Change_ToDay():
	self.color = DayColor


func HideShow(node):
	if(node.visible == true):
		node.visible == false
	else:
		node.visible == true
