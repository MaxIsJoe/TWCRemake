extends Light2D

onready var DaynNightbehavior = get_node("/root/dayNnight")

func _ready():
	pass
	#if(DaynNightbehavior.Day):
		#Light2D.Color = transparentcolor
	#if(DayNightbehavior.Night):
		#apply the same color as the night's color in the orignal game