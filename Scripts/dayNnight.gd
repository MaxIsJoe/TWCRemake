extends Node

var Day = true
var Night = false
var timer
var WaitForNextTimeOfDay = 3000

func _ready():
	timer = Timer.new()
	timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(timer)
	timer.wait_time = WaitForNextTimeOfDay
	timer.start()

func _on_timer_timeout():
   TimeMove()

func TimeMove():
	if(Day):
		Night = true
		Day = false
		return
	if(Night):
		Day = true
		Night = false
		return