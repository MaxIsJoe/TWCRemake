extends Control

var version = "0.0.1" #Used to display the game's version, should be updated later to make this a variable found in a config file or something like that.
var selecteditemG
var selectitemH
var ForbiddenNames = ["robed figure",
				"masked figure",
				"deatheater",
				"auror",
				"harry",
				"potter",
				"albus",
				"malfoy",
				"snape",
				"hermoine",
				"voldemort",
				"dumbledore",
				"riddle",
				"potter",
				"granger",
				"malfoy",
				"weasley",
				"lestrange",
				"sirius",
				"riddle",
				"lestrange",
				"black",
				"marvello",
				"ben copper",
				"penny haywood",
				"muller sydney",
				"muller"] #These are the forbidden names that the player cannot use, it's the same list from the original game.
				
#var TestWorld = "res://Scenes/TestWorld_2.tscn" 
#var TestWorldSpawnPostion = Vector2(90,90)

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
onready var NetworkingPage = $NetworkingPage

func _ready():
	versionlabel.text = version
	add_items() #Adds items to the drop down menu to be used
	disable_items(0)
	selecteditemG = 0
	selectitemH = 0

func _on_StartButton_pressed():
	mainpage.visible = false
	NetworkingPage.visible = true
	
func add_items():
	dropdownGender.add_item("Select your gender")
	dropdownGender.add_item("Wizard")
	dropdownGender.add_item("Witch")
	dropdownHouse.add_item("Select your house")
	dropdownHouse.add_item("Gryffindor")
	dropdownHouse.add_item("Hufflepuff")
	dropdownHouse.add_item("Ravenclaw")
	dropdownHouse.add_item("Slytherin")

func disable_items(id):
	dropdownGender.set_item_disabled(id, true)
	dropdownHouse.set_item_disabled(id, true)


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
	if(selecteditemG == 0 or null):
		warninglabel.text = "Please select your character's gender"
		return
	if(selectitemH == 0 or null):
		warninglabel.text = "Please choose a house"
		return
	if(ForbiddenNames.has(CharacterName)):
		warninglabel.text = "Please select another name"
		return
	#Spawn the player with their name and gender assigned to them
	CreateThePlayer(CharacterName, selecteditemG,selectitemH)
	#rpc_id(1 , "CreateThePlayer", CharacterName, selecteditemG,selectitemH)

func _on_SelectGender_item_selected(ID):
	selecteditemG = ID


func _on_ExitButiion_pressed():
	get_tree().quit()


func _on_SelectHouse_item_selected(ID):
	selectitemH = ID
	
func CreateThePlayer(charname,gender,house):
	NetworkingFunctions.rpc_id(1 , "CreateThePlayer", charname, selecteditemG,selectitemH, DiagonAlley, DiagonAlleySpawnPos)

func _on_CreateServer_pressed():
	if PlayerID == "":
		return
	Network.create_server(PlayerID)
	NetworkingPage.visible = false
	charactersetup.visible = true

func _on_JoinServer_pressed():
	if PlayerID == "":
		return
	Network.connect_to_server(PlayerID)
	NetworkingPage.visible = false
	charactersetup.visible = true


func _on_TakePlayerName_text_changed(new_text):
	PlayerID = $NetworkingPage/Background/TakePlayerName.text
