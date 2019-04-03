extends KinematicBody2D

onready var Quick_Dia = $Quick_Dia
onready var Dialoug = $Holders/DialougHolder
onready var TimerNode = $Timer

export(String) var NPC_Name = "NPC"
export(String) var Desc = "No description"
export(int) var health = 39000
export(bool) var CanMove = false
export(bool) var CanDie = false
export(bool) var HasShop = false
export(bool) var HasQuests = false



func _on_Timer_timeout():
	Dialoug.QuickDialoug()
	


func _on_DialougHolder_send_text(text):
	Quick_Dia.bbcode_text = "[center]" + text
