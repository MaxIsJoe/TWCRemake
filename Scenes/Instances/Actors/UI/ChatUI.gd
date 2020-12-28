extends Control

export(Color) var Player_InView_Color
export(Color) var OOC_Color 
export(Color) var NPC_Color
export(Color) var Event_Color 
export(Color) var System_Color

onready var TextDisplay = $Background/VBoxContainer/RichTextLabel
onready var bg = $Background
onready var vis_tween = $T/T_Background
onready var timer_bg = $T/T_ShowAndHideTime
onready var timer_txt = $T/T_Text2

var is_visible = false
var is_focused = false

var selected_saymode

func _ready():
	$Background/VBoxContainer/Write/HBoxContainer/SayOption.add_item("Say")
	$Background/VBoxContainer/Write/HBoxContainer/SayOption.add_item("OOC")
	selected_saymode = 0
	Data.Chat = self
	
	
func _input(event):
	pass

sync func Send_System_Text(txt):
	var TxtToBeSent = str("[color=][System] - " + txt + "[/color]\n")
	var TxtSent = ReplaceColor(TxtToBeSent, System_Color)
	rpc("receive_message", TxtSent)
	ShowUI()

sync func Send_OOC_Text(txt, sender):
	$Background/VBoxContainer/Write/HBoxContainer/LineEdit.text = ""
	var TxtToBeSent =  str("[color=]<OOC>" + sender + "[/color]: " + txt + "\n")
	var TxtSent = ReplaceColor(TxtToBeSent, OOC_Color)
	rpc("receive_message", TxtSent)
	ShowUI()
	
sync func Send_InView_Text(txt, sender):
	$Background/VBoxContainer/Write/HBoxContainer/LineEdit.text = ""
	var TxtToBeSent =  str("[color=]" +sender + "[/color]: " + txt + "\n")
	var TxtSent = ReplaceColor(TxtToBeSent, Player_InView_Color)
	rpc("receive_message", TxtSent)
	ShowUI()

func ReplaceColor(text, color):
	var result = text.replace("[color=]", str("[color=#" + color.to_html(false) + "]"))
	return result
	
func ShowUI():
	var is_visible = true
	vis_tween.interpolate_property(bg, "color", Color(0.4,0.4,0.4,0), Color(0.4,0.4,0.4,0.23), 0.2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	vis_tween.start()
	vis_tween.interpolate_property(bg, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	vis_tween.start()
	timer_bg.start()
	timer_txt.start()

sync func receive_message(text):
	TextDisplay.bbcode_text += text

func _on_T_ShowAndHideTime_timeout():
	if(is_visible and is_focused != true):
		vis_tween.interpolate_property(bg, "color", Color(0.4,0.4,0.4,0.23), Color(0.4,0.4,0.4,0), 0.2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		vis_tween.start()
		is_visible = false


func _on_T_Text2_timeout():
	if(!is_visible and is_focused != true):
		vis_tween.interpolate_property(bg, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		vis_tween.start()


func _on_SayOption_item_selected(index):
	selected_saymode = index


func _on_LineEdit_text_entered(new_text):
	if(selected_saymode == 0):
			Send_InView_Text(new_text, Data.Player.PlayerName)
	if(selected_saymode == 1):
			Send_OOC_Text(new_text, Data.Player.PlayerName)


func _on_Background_mouse_entered():
	if(!is_visible and !is_focused):
		ShowUI()


func _on_LineEdit_focus_entered():
	is_focused = true


func _on_LineEdit_focus_exited():
	is_focused = false
