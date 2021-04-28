extends "res://Scenes/Instances/EntitesBase/Characters/CharacterEntity.gd"

var Gender
var House
var PlayerName
var PlayerYear: int
var gold: int

var CanDrawWand: bool  = true #Used dueling
var WandDrawn  : bool  = false #Used to check if they can cast a spell or not

enum LookDirections {UP,LEFT,RIGHT,DOWN}
var LookingDirection

var ItemsArray = []

var PlayerState = {} #For networking
var playerkey #For saving and account mangement

onready var LevelUpAnim = $Cam/CanvasLayer/UI/Leveup/LevelUpAnim
onready var PlayerNameUI = $PlayerName
onready var tabs = $Cam/CanvasLayer/UI/TabContainer
onready var ScrollUI = $Cam/CanvasLayer/UI/Scroll
onready var PopUpUI = $Cam/CanvasLayer/UI/WindowDialog
onready var AudioLocal = $Audio/Audio_Pos
onready var Audio = $Audio/Audio
onready var Shootpoint = $Spell_Pointers/ShootPoint
onready var TargertPoint = $Spell_Pointers/TargetPoint

func _ready():
	playerkey = Data.main_node.key
	
	if(is_network_master()):
		$Cam.current = true
		$Cam/CanvasLayer/UI.visible = true
		Data.Player = self
		if(Global.EnableFOV):
			$Light2D.shadow_enabled = true
		else:
			$Light2D.shadow_enabled = false
		if(get_tree().get_network_unique_id() != 1):
			rpc_id(1, "SendKeyToServer", playerkey)
		else:
			SendKeyToServer(playerkey)
		NetworkManager.Network.rpc("AddActiveKey", playerkey)
	
	Send_PlayerState()
	
func SetupPlayer(house: int, Name: String, gender: int):
	PlayerName = Name
	Gender = gender
	House = house
	
	SetupBodySprites()
	updatenamelabel()
	
func Send_PlayerState():
	PlayerState = {"T": OS.get_system_time_msecs(), "P": global_position, "A": SpriteHandler.currentDir, "LD": LookingDirection, "D": stats.damage, "SP": Shootpoint.global_transform}
	NetworkManager.Network.rpc_unreliable("SendData", PlayerState)
	
func UpdatePlayer(pos, anim, ld, d, SP):
	global_position = lerp(global_position, pos, 0.8)
	SpriteHandler.PlayDirectionalAnimAll(anim)
	LookingDirection = ld
	stats.damage = d
	Shootpoint = SP

func GetSavePlayerInfo():
	var info = {"N": PlayerName, 
	"H": House, 
	"G": Gender, 
	"D": stats.damage, 
	"Year": PlayerYear, 
	"lvl": stats.level, "EXP": stats.XP, "MEXP": stats.XP_MAX, 
	"gold": gold, 
	"HP": health.HP, "mHP": health.HP_MAX, "MP": stats.mana, "MMP": stats.mana_max,
	"StatPoints": stats.statpoints, "SpellPoints": stats.spellppoints,
	"vx": global_position.x,
	"vy": global_position.y,
	"key": playerkey}
	if(info.get("key") == null): push_warning("\a Warning, Key is null.")
	return info

remote func SendKeyToServer(key):
	playerkey = key

remote func updatenamelabel():
	PlayerNameUI.text = str(PlayerName)
	if(House == 0):
		PlayerNameUI.add_color_override("font_color", Color(0.86,0.08,0.24,1))
	if(House == 1):
		PlayerNameUI.add_color_override("font_color", Color(1,0.84,0,1))
	if(House == 3):
		PlayerNameUI.add_color_override("font_color", Color(0,1,0,1))
	if(House == 2):
		PlayerNameUI.add_color_override("font_color", Color(0,1,1,1))

func _physics_process(delta):
	if is_network_master():
		getDir()
	Send_PlayerState()

func SetupBodySprites():
	match Gender:
		0:
			match House:
				0:
					SpriteHandler.LoadAnimatedSprites(Data.Grif_Male, BodySprites)
				1:
					SpriteHandler.LoadAnimatedSprites(Data.Huff_Male, BodySprites)
				2:
					SpriteHandler.LoadAnimatedSprites(Data.Claw_Male, BodySprites)
				3:
					SpriteHandler.LoadAnimatedSprites(Data.Slyth_Male, BodySprites)
		1:
			match House:
				0:
					SpriteHandler.LoadAnimatedSprites(Data.Grif_Female, BodySprites)
				1:
					SpriteHandler.LoadAnimatedSprites(Data.Huff_Female, BodySprites)
				2:
					SpriteHandler.LoadAnimatedSprites(Data.Claw_Female, BodySprites)
				3:
					SpriteHandler.LoadAnimatedSprites(Data.Slyth_Female, BodySprites)


func getDir():
	moveDir.x = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	moveDir.y = -int(Input.is_action_pressed("move_up")) + int(Input.is_action_pressed("move_down"))
