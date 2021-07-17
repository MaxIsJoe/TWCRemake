extends CanvasLayer

var withdrawText = "how much would you like to withdraw?"
var depositText  = "how much would you like to deposit?"

onready var label = $Panel/Label

var mode : int = 0

func ShowUI(newMode: int):
	match newMode:
		0:
			mode = 0
			label.text = withdrawText
			$Panel/SpinBox.max_value = Bank.howMuchMoneyDoesThisPlayerHave(Data.main_node.key)
			$Panel/SpinBox.value = $Panel/SpinBox.max_value
		1:
			mode = 1
			label.text = depositText
			$Panel/SpinBox.max_value = Data.Player.gold
			$Panel/SpinBox.value = Data.Player.gold



func _on_Confirm_button_down():
	match mode:
		0:
			Bank.withdraw(Data.main_node.key, $Panel/SpinBox.value, Data.Player)
		1:
			Bank.desposit(Data.main_node.key, $Panel/SpinBox.value, Data.Player)
	queue_free()


func _on_Cancel_button_down():
	queue_free()
