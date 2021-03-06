extends CanvasLayer

var version = Global.version #Used to display the game's version, should be updated later to make this a variable found in a config file or something like that.
var selecteditemG
var selectitemH

var PlayerID = ""


#Here we define where new players will load into and where their position will be.
var DiagonAlley = "res://Scenes/Levels/DiagonAlley.tscn"
var DiagonAlleySpawnPos = Vector2(782,177)

export (NodePath) var dropdown_path

#All the importat things that needs to referenced and defined
onready var versionlabel = $MainPage/Version
onready var charactersetup = $CharacterPage
onready var mainpage = $MainPage
onready var dropdownGender = $CharacterPage/SelectGender
onready var dropdownHouse = $CharacterPage/SelectHouse
onready var warninglabel = $CharacterPage/Warning
onready var timeout = $Timeout

remote var hascharacter : bool = false
remote var saveddata : Dictionary = {}

var timeout_counter = -1

var playeruniqueID : int

func _ready():
	versionlabel.text = version
	add_items() #Adds items to the drop down menu to be used
	disable_items()
	selecteditemG = 2
	selectitemH = 4
	dropdownGender.selected = 2
	dropdownHouse.selected = 4

func ShowStartingPage():
	$Background.visible = true
	mainpage.visible = true
	$AnimationPlayer.play("ShowUI")
	
func HideStartingPage():
	$Background.visible = false
	mainpage.queue_free()
	charactersetup.queue_free()

func _on_StartButton_pressed():
	playeruniqueID = get_tree().get_network_unique_id()
	Data.main_node.Map.visible = true
	NetworkManager.Network.rpc_id(1, "GetActiveKeys")
	$MainPage/StartButton.disabled = true
	$MainPage/StartButton.text = "Loading.."
	hascharacter = false
	if(playeruniqueID != 1):
		rpc_id(1, "DoesHeAlreadyHaveACharacter", Data.main_node.key, get_tree().get_network_unique_id())
	else:
		DoesHeAlreadyHaveACharacter(Data.main_node.key, get_tree().get_network_unique_id())
	
	while hascharacter == false:
		if(timeout_counter >= 10):
			$MainPage/StartButton.text = "Connection unstable."
			$MainPage/StartButton.disabled = false
			timeout_counter = -1
			break
		else:
			timeout.start()
			yield(timeout, "timeout")
			timeout_counter += 1
			
	if(hascharacter):
		saveddata = {}
		
		if(playeruniqueID != 1):
			NetworkManager.Network.rpc_id(1, "GetSavedPlayerData", Data.main_node.key, get_tree().get_network_unique_id())
		else:
			NetworkManager.Network.GetSavedPlayerData(Data.main_node.key, get_tree().get_network_unique_id())
		
		while saveddata.size() == 0:
			if(timeout_counter >= 10):
				$MainPage/StartButton.text = "Connection unstable."
				$MainPage/StartButton.disabled = false
				timeout_counter = -1
				break
			else:
				timeout.start()
				yield(timeout, "timeout")
				timeout_counter += 1
				
		NetworkManager.Functions.rpc_id(0, "CreateThePlayer", str(saveddata["N"]), int(saveddata["G"]), int(saveddata["H"]), null, Vector2(int(saveddata["vx"]), int(saveddata["vy"])), get_tree().get_network_unique_id())
		if(playeruniqueID != 1):
			NetworkManager.Network.rpc_id(1, "CreateActivePlayers", get_tree().get_network_unique_id())
		else:
			NetworkManager.Network.CreateActivePlayers(get_tree().get_network_unique_id())
		Data.main_node.UI_Chat.SendText(0, str(saveddata["N"] + " logged in."), "")
		Data.main_node.CanOpenPauseMenu = true
		Data.main_node.PauseScreen.BuildPlayerWhoList()
		HideStartingPage()
	else:
		mainpage.visible = false
		charactersetup.visible = true
	
remote func DoesHeAlreadyHaveACharacter(key, id):
	var file
	var dir = Directory.new()
	if dir.open("user://saves/") == OK:
		dir.list_dir_begin(true, true)
		while file != "": #(Max): I have no idea what's going on here but it works so I'm not messing with it.
			if(file != null):
				if(file.begins_with(str(key))):
					if(playeruniqueID != 1):
						rset_id(id, "hascharacter", true) #Tell the client that his account does exist
					else:
						print("Setting hascharacter to true")
						hascharacter = true
					break
			file = dir.get_next()
	else:
		print("Failed to open user://saves/")
	
func add_items():
	dropdownGender.add_item("Wizard")
	dropdownGender.add_item("Witch")
	dropdownGender.add_item("Select your gender")
	dropdownHouse.add_item("Gryffindor")
	dropdownHouse.add_item("Hufflepuff")
	dropdownHouse.add_item("Ravenclaw")
	dropdownHouse.add_item("Slytherin")
	dropdownHouse.add_item("Select your house")

func disable_items():
	dropdownGender.set_item_disabled(2, true)
	dropdownHouse.set_item_disabled(4, true)


func _on_FinishCharSetup_pressed():
	warninglabel.text = ""
	var CharacterName = $CharacterPage/SelectName.text
	print("The Character's name is" , CharacterName, "And their gender is" ,selecteditemG)
	#Check if the player has filled everything in correctly
	if(CharacterName.length() < 3):
		warninglabel.text = "Please enter a name longer than three characters"
		return
	if(CharacterName.length() > 16):
		warninglabel.text = "Please use a shorter name"
		return
	if(selecteditemG == 2 or null):
		warninglabel.text = "Please select your character's gender"
		return
	if(selectitemH == 4 or null):
		warninglabel.text = "Please choose a house"
		return
	if(Data.ForbiddenNames.has(CharacterName)):
		warninglabel.text = "Please select another name"
		return
	#Spawn the player with their name and gender assigned to them
	CreateThePlayer(CharacterName)
	#rpc_id(1 , "CreateThePlayer", CharacterName, selecteditemG,selectitemH)

func _on_SelectGender_item_selected(ID):
	selecteditemG = ID


func _on_ExitButiion_pressed():
	get_tree().quit()


func _on_SelectHouse_item_selected(ID):
	selectitemH = ID
	
func CreateThePlayer(charname):
	if(playeruniqueID != 1):
		NetworkManager.Network.rpc_id(1, "GetActiveKeys")
	else:
		NetworkManager.Network.GetActiveKeys()
	NetworkManager.Functions.rpc_id(0, "CreateThePlayer", charname, selecteditemG,selectitemH, DiagonAlley, DiagonAlleySpawnPos, get_tree().get_network_unique_id())
	Data.main_node.UI_Chat.SendText(0, str(charname + " logged in."), "")
	if(playeruniqueID != 1):
		NetworkManager.Network.rpc_id(1, "CreateActivePlayers", get_tree().get_network_unique_id())
	else:
		NetworkManager.Network.CreateActivePlayers(get_tree().get_network_unique_id())
	HideStartingPage()
