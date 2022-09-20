extends MobEntity
class_name MobEnity_NPC

@export var NPC_Name: String = "NPC" #NPC Name, used for various things.
@export var Desc: String = "No description" #NPC description, will be used later.
@export var ID: int = 000 #The NPC's ID is used to accsess data about them
@export var InteractionDistance: float = 120 #The distance where an NPC can be interacted with
@export var CanWander: bool = false #Can this NPC freely move?
@export var HasQuickDialouge: bool = false #Does he have quick dialouge above this head?
@export var HasDialouge: bool #Can you start conversations with this NPC?
@export var HasShop: bool = false #Can you buy items from this NPC?
@export var HasQuests: bool = false #Does this NPC have quests that need to be tracked?

@onready var Quick_Dia = $Quick_Dia
@onready var Dialoug = $Holders/DialougHolder
@onready var shop = $Holders/ShopHolder
@onready var acknowledgement_area = $Acknowledgement_area #Used to acknolwadge the player's existence

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
		#disable untill fix
		#acknowleged_player_names.append(str(body.PlayerName))
		pass

func _on_Acknowledgement_area_body_exited(body):
	if(body.is_in_group("Players")):
		#disable untill fix
		#acknowleged_player_names.remove_at(str(body.PlayerName))
		pass
		
func _on_QuickDiaCooldown_timeout():
	quicktext = Dialoug.GetQuickDia()
	Quick_Dia.text = str(quicktext)
	$Quick_Dia/Tween.interpolate_property(Quick_Dia, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.8, Tween.TRANS_CUBIC,Tween.EASE_IN_OUT)
	$Quick_Dia/Tween.start()
	$Cooldowns/QuickDiaVisibiltyCooldown.start()


func _on_NPCBase_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		var distance2player = Global.GetDistance2Player(self)
		if(distance2player <= InteractionDistance):
			if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
				$RadialMenu.ToggleButtonVisbility(true)
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and HasDialouge:
			Dialoug.StartDialogue("")
			return
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and Input.is_action_pressed("shift"):
			if(distance2player <= InteractionDistance * 1.5):
				Data.main_node.UI_Chat.SendText(3, Desc, "")
			else:
				Data.main_node.UI_Chat.SendText(3, "You're too far to inspect this!", "")
				

func TalkToNPC():
	if(Dialoug.Dialogic_Timeline != ""):
		Dialoug.StartDialogue()

func _on_QuickDiaVisibiltyCooldown_timeout():
	$Quick_Dia/Tween.interpolate_property(Quick_Dia, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.8, Tween.TRANS_CUBIC,Tween.EASE_IN_OUT)
	$Quick_Dia/Tween.start()

