extends KinematicBody2D

const SPEED = 150

export(String) var NPC_Name = "NPC"
export(String) var Desc = "No description"
export(int) var ID = 000
export(int) var health = 39000
export(float) var InteractionDistance = 120
export(float) var WanderRadius = 140.0
export(bool) var CanWander = false
export(bool) var CanDie = false
export(bool) var HasQuickDialouge = false
export(bool) var HasDialouge
export(bool) var HasShop = false
export(bool) var HasQuests = false

onready var Quick_Dia = $Quick_Dia
onready var Dialoug = $Holders/DialougHolder
onready var TimerNode = $Cooldowns/Timer
onready var VisableCharactersTimer = $Quick_Dia/Visable_Chars
onready var acknowledgement_area = $Acknowledgement_area

var acknowleged_player_names = []
var IsGreetingAPlayer = false
var busy = false
var Moving = false
#var state = STATE_WANDERING
var quicktext


func _ready():
	input_pickable = true
	if(HasQuickDialouge):
		quicktext = JsonLoader.LoadJSON_Retrun($Holders/DialougHolder.QuickDialougFile)
		$Cooldowns/QuickDiaCooldown.start()
	if(!HasQuickDialouge):
		$Quick_Dia.visible = false
		$Cooldowns/QuickDiaCooldown.stop()
	if(HasShop):
		$RadialMenu.LoadButton("Shop", ID)
	if(HasQuests):
		$RadialMenu.LoadButton("Quests", ID)
	if(HasDialouge):
		$RadialMenu.LoadButton("Dialouge", ID)
		

func _on_Acknowledgement_area_body_entered(body):
	if(body.is_in_group("Players")):
		acknowleged_player_names.append(body.PlayerName)

func _on_Acknowledgement_area_body_exited(body):
	if(body.is_in_group("Players")):
		acknowleged_player_names.remove(body.PlayerName)


func _on_QuickDiaCooldown_timeout():
	quicktext = Dialoug.GetQuickDia()
	$Quick_Dia.bbcode_text = str(quicktext)


func _on_NPCBase_input_event(viewport, event, shape_idx):
	var distance2player = Global.GetDistance2Player(self)
	if(distance2player <= InteractionDistance):
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_RIGHT and event.pressed:
				$RadialMenu.ToggleButtonVisbility(true)
				print("it's working")
