extends TextureButton

export(int) var ButtonHotkey = 0


onready var time_label = $ButtonCooldown

var cooldown = 1.0
var Action
var ActionArguments = []


func AddAction(action, GivenActionArguments, ActionCooldown, icon):
	Action = action
	var value = GivenActionArguments.split(" ")
	for argument in value:
		ActionArguments.append(argument)
	cooldown = ActionCooldown
	$Timer.wait_time = cooldown
	$TextureRect.texture = load(icon)
	disabled = false

func _ready():
	disabled = true
	$Timer.wait_time = cooldown
	time_label.hide()
	$TextureProgress.texture_progress = texture_normal
	$TextureProgress.value = 0
	$ButtonHotkey.text = str(ButtonHotkey)
	set_process(false)
	
func _process(delta):
	time_label.text = "%3.1f" % $Timer.time_left
	$TextureProgress.value = int(($Timer.time_left / cooldown) * 100)
	
func _on_Timer_timeout():
	$TextureProgress.value = 0
	disabled = false
	time_label.hide()
	set_process(false)


func _on_HotkeyButton_button_down():
	print(ActionArguments)
	match ActionArguments.size():
		null:
			Data.Player.call(Action)
			$Timer.start()
			set_process(true)
			disabled = true
		0:
			Data.Player.call(Action)
			$Timer.start()
			set_process(true)
			disabled = true
		1:
			Data.Player.call(Action, ActionArguments[0])
			$Timer.start()
			set_process(true)
			disabled = true
		2:
			Data.Player.call(Action, ActionArguments[0], ActionArguments[1])
			$Timer.start()
			set_process(true)
			disabled = true
		3:
			Data.Player.call(Action, ActionArguments[0], ActionArguments[1], ActionArguments[2])
			$Timer.start()
			set_process(true)
			disabled = true
		4:
			Data.Player.call(Action, ActionArguments[0], ActionArguments[1], ActionArguments[2], ActionArguments[3])
			$Timer.start()
			set_process(true)
			disabled = true
