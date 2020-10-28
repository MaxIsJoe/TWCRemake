extends TextureButton


var ButtonName
var DialougeID
var Condetion
var DiaFile = null


func _ready():
	$Tween.interpolate_property(self, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.8, Tween.TRANS_CUBIC,Tween.EASE_IN_OUT)
	$Tween.start()

func InitlizeButtonName(Name):
	ButtonName = Name
	$RichTextLabel.bbcode_text = ButtonName
	
func InitlizeButtonID(ID):
	DialougeID = ID
	
func InitlizeCondtions(Cond):
	Condetion = Cond
#	CheckCondtions()

#func CheckCondtions():
#	if(Condetion.begins_with("HasMoney")):
#		var value = Condetion.split(" ")
#		if(PlayerGlobalVariables.Vars.get("money") < value[1]):
#			self.disabled = true

func _on_ChoiceButton_button_up():
	print("choice made:" + $RichTextLabel.bbcode_text)
	Global.LoadDialouge(DiaFile, DialougeID)
	var v = get_tree().get_nodes_in_group("DiaUI")
	var s = get_tree().get_nodes_in_group("DiaButtons")
	for p in v:
		p.emit_signal("StartDialougRemotely")
		p.ClearChoices()
