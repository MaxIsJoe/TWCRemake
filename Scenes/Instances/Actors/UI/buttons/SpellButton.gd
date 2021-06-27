extends Button

var SpellID

func UpdateButton(Name, Icon, ID):
	text = Name
	icon = load(Icon)
	SpellID = ID

func _on_SpellButton_button_down():
	Data.Player.ShowHotkeyAsign(SpellID)
