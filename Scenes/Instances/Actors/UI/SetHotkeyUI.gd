extends Control

var ID

func _on_Button2_button_down():
	visible = false


func _on_Button_button_down():
	print(Data.SpellsData[ID].get("ActionArguments"))
	Data.Player.AddSpellForHotkey($PopupPanel/SpinBox.value, Data.SpellsData[ID].get("Action"), Data.SpellsData[ID].get("ActionArguments"), Data.SpellsData[ID].get("ActionCooldown"), Data.SpellsData[ID].get("SpellIcon"))
