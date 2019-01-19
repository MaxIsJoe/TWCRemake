extends Node

var Day = true
var Night = false
var timer
var WaitForNextTimeOfDay = 4

func _ready():
	timer = Timer.new()
	timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(timer)
	timer.wait_time = WaitForNextTimeOfDay
	timer.one_shot = false
	timer.start()

func _on_timer_timeout():
   TimeMove()
   print("Ding!")

func TimeMove():
	if(Day == false):
		Night = true
		Day = false
		print(Day, Night)
	if(Night == false):
		Day = true
		Night = false
		print(Day, Night)


func ChangeToDay(sprite):
	sprite.modulate = Color( 225, 225, 225, 0 )
	
func ChangeToNight(sprite):
	sprite.modulate = Color( 17, 5, 73, 121)
