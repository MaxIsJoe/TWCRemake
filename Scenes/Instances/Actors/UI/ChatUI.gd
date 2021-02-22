extends Control

export(Color) var Player_InView_Color
export(Color) var OOC_Color 
export(Color) var NPC_Color
export(Color) var Event_Color 
export(Color) var System_Color

onready var TextDisplay = $Background/VBoxContainer/RichTextLabel
onready var vis_tween = $T/T_Background

var is_visible = false

var selected_saymode

func _ready():
	###Add the selectable chat modes###
	$Background/VBoxContainer/Write/HBoxContainer/SayOption.add_item("Say")
	$Background/VBoxContainer/Write/HBoxContainer/SayOption.add_item("OOC")
	###Selected mode will be Talk-In-View###
	selected_saymode = 0
	

func SendText(Mode:int, txt:String, sender:String):
	match Mode:
		0: #System
			var TxtToBeSent = str("[color=][System] - " + txt + "[/color]\n")
			var TxtSent = ReplaceColor(TxtToBeSent, System_Color)
			rpc("receive_message", TxtSent)
		1: #Talk to players in your view only (Will work on that functionality later, for now it will act like OOC)
			$Background/VBoxContainer/Write/HBoxContainer/LineEdit.text = ""
			var TxtToBeSent =  str("[color=]" +sender + "[/color]: " + txt + "\n")
			var TxtSent = ReplaceColor(TxtToBeSent, Player_InView_Color)
			rpc("receive_message", TxtSent)
		2: #ooc
			$Background/VBoxContainer/Write/HBoxContainer/LineEdit.text = ""
			var TxtToBeSent =  str("[color=]<OOC>" + sender + "[/color]: " + txt + "\n")
			var TxtSent = ReplaceColor(TxtToBeSent, OOC_Color)
			rpc("receive_message", TxtSent)



func ReplaceColor(text, color): #Replaces the text color to the desired color
	var result = text.replace("[color=]", str("[color=#" + color.to_html(false) + "]"))
	return result
	
func ShowUI(): #Moves the UI smoothly off and back on screen
	if(is_visible == false):
		vis_tween.interpolate_property(self, "rect_position", Vector2(1281.142,0), Vector2(878.629,0), 0.2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		is_visible = true
	else:
		vis_tween.interpolate_property(self, "rect_position", Vector2(878.629,0), Vector2(1281.142,0), 0.2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		is_visible = false
	vis_tween.start()

remotesync func receive_message(text):
	TextDisplay.bbcode_text += text

func _on_SayOption_item_selected(index):
	selected_saymode = index

func _on_LineEdit_text_entered(new_text):
	if(new_text != ""): #If there is no text, don't do anything
		SendText(int(selected_saymode + 1), new_text, Data.Player.PlayerName)
		#selected_saymode must always added by one because Mode starts at 0
		#Say and OOC are 1 and 2 in SendText, if you don't add by one then you'll instead run a system message or a say message since System is 0 and Say is 1

func _on_ShowChatButton_button_down():
	ShowUI()
