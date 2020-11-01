extends TextureButton

export(int) var ButtonHotkey = 0


onready var time_label = $ButtonCooldown

var cooldown = 1.0
var Action
var ActionArguments = []


func AddAction(action, GivenActionArguments, ActionCooldown, icon):
	Action = action
	ActionArguments.append(GivenActionArguments)
	cooldown = ActionCooldown
	$TextureRect.texture = load(icon)

func _ready():
	$Timer.wait_time = cooldown
	time_label.hide()
	$TextureProgress.texture_progress = texture_normal
	$TextureProgress.value = 0
	$ButtonHotkey.text = str(ButtonHotkey)
	set_process(false)
	
func _process(delta):
	time_label.text = "%3.1f" % $Timer.time_left
	$Sweep.value = int(($Timer.time_left / cooldown) * 100)
	
func _on_Timer_timeout():
	print("ability ready")
	$TextureProgress.value = 0
	disabled = false
	time_label.hide()
	set_process(false)


func _on_HotkeyButton_button_down():
	print(ActionArguments)
	match ActionArguments.size():
		null:
			Data.Player.call(Action)
		0:
			Data.Player.call(Action)
		1:
			Data.Player.call(Action, ActionArguments[0])
		2:
			Data.Player.call(Action, ActionArguments[0], ActionArguments[1])
		3:
			Data.Player.call(Action, ActionArguments[0], ActionArguments[1], ActionArguments[2])
		4:
			Data.Player.call(Action, ActionArguments[0], ActionArguments[1], ActionArguments[2], ActionArguments[3])
