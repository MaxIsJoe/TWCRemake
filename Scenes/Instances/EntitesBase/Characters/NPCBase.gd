extends MobEntity
class_name MobEnity_NPC

export(String) var NPC_Name = "NPC" #NPC Name, used for various things.
export(String) var Desc = "No description" #NPC description, will be used later.
export(int) var ID = 000 #The NPC's ID is used to accsess data about them
export(float) var InteractionDistance = 120 #The distance where an NPC can be interacted with
export(bool) var CanWander = false #Can this NPC freely move?
export(bool) var HasQuickDialouge = false #Does he have quick dialouge above this head?
export(bool) var HasDialouge #Can you start conversations with this NPC?
export(bool) var HasShop = false #Can you buy items from this NPC?
export(bool) var HasQuests = false #Does this NPC have quests that need to be tracked?

onready var Quick_Dia = $Quick_Dia
onready var Dialoug = $Holders/DialougHolder
onready var shop = $Holders/ShopHolder
onready var acknowledgement_area = $Acknowledgement_area #Used to acknolwadge the player's existence

var acknowleged_player_names = []
var busy = false
var Moving = false
var quicktext


func _ready():
	$NPCName.text = NPC_Name
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
	Quick_Dia.bbcode_text = str(quicktext)
	$Quick_Dia/Tween.interpolate_property(Quick_Dia, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.8, Tween.TRANS_CUBIC,Tween.EASE_IN_OUT)
	$Quick_Dia/Tween.start()
	$Cooldowns/QuickDiaVisibiltyCooldown.start()


func _on_NPCBase_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		var distance2player = Global.GetDistance2Player(self)
		if(distance2player <= InteractionDistance):
			if event.button_index == BUTTON_RIGHT and event.pressed:
				$RadialMenu.ToggleButtonVisbility(true)
		if event.button_index == BUTTON_LEFT and event.pressed and Input.is_action_pressed("shift"):
			if(distance2player <= InteractionDistance * 1.5):
				Data.main_node.UI_Chat.SendText(3, Desc, "")
			else:
				Data.main_node.UI_Chat.SendText(3, "You're too far to inspect this!", "")
				

func _on_QuickDiaVisibiltyCooldown_timeout():
	$Quick_Dia/Tween.interpolate_property(Quick_Dia, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.8, Tween.TRANS_CUBIC,Tween.EASE_IN_OUT)
	$Quick_Dia/Tween.start()

