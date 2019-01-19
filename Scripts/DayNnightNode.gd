extends Sprite

onready var DaynNightbehavior = get_node("/root/dayNnight")

var IsDay = true
var IsNight = false

func _ready():
	if(DaynNightbehavior.Day):
		DaynNightbehavior.ChangeToDay(self)
	else:
		DaynNightbehavior.ChangeToNight(self)
	print(modulate)
	
func _process(delta):
	DaynNightbehavior.TimeMove()
	if(DaynNightbehavior.Day):
		if(IsDay):
			print("Has checked day")
		if(!IsDay):
			print("changed to Night")
			DaynNightbehavior.ChangeToNight(self)
			IsDay = false
			IsNight = true
	if(DaynNightbehavior.Night):
		if(IsNight):
			print("has changed night")
		if(!IsNight):
			print("has changed to day")
			DaynNightbehavior.ChangeToDay(self)
			IsDay = true
			IsNight = false