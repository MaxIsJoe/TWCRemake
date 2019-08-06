extends ColorRect

onready var DaynNightbehavior = get_node("/root/dayNnight")

var IsDay = false
var IsNight = true

func _ready():
	DaynNightbehavior
	if(DaynNightbehavior.Day):
		#DaynNightbehavior.ChangeToDay(self)
		#DaynNightbehavior.HideShow(self)
		IsDay = true
		IsNight = false
	else:
		#DaynNightbehavior.ChangeToNight(self)
		#DaynNightbehavior.HideShow(self)
		IsDay = false
		IsNight = true
	#print(modulate)
	#print(DaynNightbehavior.Day , DaynNightbehavior.Night)
	
func _ChangeToNight():
	self.color = Global.NightColor
func _ChangeToDay():
	self.color = Global.DayColor
	
func _process(delta):
	#The way of doing this is horrible and needs improvments
	if(DaynNightbehavior.Day == true):
		_ChangeToDay()
		#DaynNightbehavior.ChangeToDay(self)
		#DaynNightbehavior.HideShow(self)
		IsDay = true
		IsNight = false
	elif(DaynNightbehavior.Night == true):
		IsDay = false
		IsNight = true
		_ChangeToNight()
		#DaynNightbehavior.ChangeToNight(self)
		#DaynNightbehavior.HideShow(self)