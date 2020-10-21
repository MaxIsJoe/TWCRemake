extends KinematicBody2D

const SPEED = 150

export(String) var NPC_Name = "NPC"
export(String) var Desc = "No description"
export(int) var health = 39000
export(float) var WanderRadius = 140.0
export(bool) var CanWander = false
export(bool) var CanDie = false
export(bool) var HasQuickDialouge = false
export(bool) var HasShop = false
export(bool) var HasQuests = false

onready var Quick_Dia = $Quick_Dia
onready var Dialoug = $Holders/DialougHolder
onready var TimerNode = $Cooldowns/Timer
onready var VisableCharactersTimer = $Quick_Dia/Visable_Chars
onready var acknowledgement_area = $Acknowledgement_area

var acknowleged_players = []
var IsGreetingAPlayer = false
var busy = false
var Moving = false
#var state = STATE_WANDERING
var quicktext


func _ready():
	if(HasQuickDialouge):
		quicktext = JsonLoader.LoadJSON_QuickDia($Holders/DialougHolder.QuickDialougFile)
		$Cooldowns/QuickDiaCooldown.start()
	if(!HasQuickDialouge):
		$Quick_Dia.visible = false
		$Cooldowns/QuickDiaCooldown.stop()


func _on_Acknowledgement_area_body_entered(body):
	if(body.is_in_group("Players")):
		acknowleged_players.append(body.PlayerName)

func _on_Acknowledgement_area_body_exited(body):
	if(body.is_in_group("Players")):
		acknowleged_players.remove(body.PlayerName)


func _on_QuickDiaCooldown_timeout():
	quicktext = Dialoug.GetQuickDia()
