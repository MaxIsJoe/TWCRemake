extends Button

var SpellID

func UpdateButton(Name, Icon, ID):
	$RichTextLabel.bbcode_text = str("[center]" + Name)
	$SpellIcon.texture = load(Icon)
	SpellID = ID

func _on_SpellButton_button_down():
	Data.Player.ShowHotkeyAsign(SpellID)
