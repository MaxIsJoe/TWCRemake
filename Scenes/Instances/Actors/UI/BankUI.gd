extends CanvasLayer

var withdrawText = "how much would you like to withdraw?"
var depositText  = "how much would you like to deposit?"

@onready var label = $Panel/Label

var mode : int = 0

func ShowUI(newMode: int):
	match newMode:
		0:
			mode = 0
			label.text = withdrawText
			if(get_tree().get_unique_id() == 1):
				$Panel/SpinBox.max_value = Bank.howMuchMoneyDoesThisPlayerHave(Data.main_node.key)
			else:
				$Panel/SpinBox.max_value = Bank.rpc("howMuchMoneyDoesThisPlayerHave", Data.main_node.key)
			$Panel/SpinBox.value = $Panel/SpinBox.max_value
		1:
			mode = 1
			label.text = depositText
			$Panel/SpinBox.max_value = Data.Player.gold
			$Panel/SpinBox.value = Data.Player.gold
	Data.Player.canMove = false



func _on_Confirm_button_down():
	match mode:
		0:
			if(get_tree().get_unique_id() == 1):
				Bank.withdraw(Data.main_node.key, $Panel/SpinBox.value, Data.Player)
			else:
				Bank.rpc("withdraw", Data.main_node.key, $Panel/SpinBox.value, Data.Player)
		1:
			if(get_tree().get_unique_id() == 1):
				Bank.desposit(Data.main_node.key, $Panel/SpinBox.value, Data.Player)
			else:
				Bank.rpc("desposit", Data.main_node.key, $Panel/SpinBox.value, Data.Player)
	Data.Player.canMove = true
	queue_free()


func _on_Cancel_button_down():
	queue_free()
