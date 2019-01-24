extends AnimatedSprite

onready var DaynNightbehavior = get_node("/root/dayNnight")

var IsDay = true
var IsNight = false

func _ready():
	if(DaynNightbehavior.Day):
		DaynNightbehavior.ChangeToDay(self)
		IsDay = true
		IsNight = false
	else:
		DaynNightbehavior.ChangeToNight(self)
		IsDay = false
		IsNight = true
	#print(modulate)
	#print(DaynNightbehavior.Day , DaynNightbehavior.Night)
	
func _process(delta):
	#The way of doing this is horrible and needs improvments
	if(DaynNightbehavior.Day == true):
		DaynNightbehavior.ChangeToDay(self)
		IsDay = true
		IsNight = false
	elif(DaynNightbehavior.Night == true):
		IsDay = false
		IsNight = true
		DaynNightbehavior.ChangeToNight(self)