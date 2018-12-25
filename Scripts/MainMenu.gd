extends Control

var version = "0.0.1"
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
				"muller"]
export (NodePath) var dropdown_path

onready var versionlabel = get_node("MainPage/Version")
onready var charactersetup = get_node("CharacterPage")
onready var mainpage = get_node("MainPage")
onready var dropdownGender = get_node("CharacterPage/SelectGender")
onready var dropdownHouse = get_node("CharacterPage/SelectHouse")
onready var warninglabel = get_node("CharacterPage/Warning")

func _ready():
	versionlabel.text = version
	add_items()
	disable_items(0)
	selecteditemG = 0
	selectitemH = 0

func _on_StartButton_pressed():
	mainpage.visible = false
	charactersetup.visible = true
	
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
	var CharacterName = get_node("CharacterPage/SelectName")
	#print("The Character's name is" , CharacterName.text, "And their gender is" ,selecteditem)
	if(CharacterName.text.length() < 3):
		warninglabel.text = "Please enter a name longer than three characters"
		return
	if(CharacterName.text.length() > 16):
		warninglabel.text = "Please use a shorter name"
		return
	if(selecteditemG == 0 or null):
		warninglabel.text = "Please select your character's gender"
		return
	if(selectitemH == 0 or null):
		warninglabel.text = "Please choose a house"
		return
	if(ForbiddenNames.has(CharacterName.text)):
		warninglabel.text = "Please select another name"
		return
	#Spawn the player with their name and gender assigned to them
	CreateThePlayer(CharacterName, selecteditemG,selectitemH)

func _on_SelectGender_item_selected(ID):
	selecteditemG = ID


func _on_ExitButiion_pressed():
	get_tree().quit()


func _on_SelectHouse_item_selected(ID):
	selectitemH = ID
	
func CreateThePlayer(charname,gender,house):
	if(gender == 1):
		if(house == 1):
			pass #add red bois
		if(house == 2):
			pass #yellow bois
		if(house == 3):
			pass #bluebois
		if(house == 4):
			pass #snak is fren
	if(gender == 2):
		if(house == 1):
			pass #red grils
		if(house == 2):
			pass #yellow grils
		if(house == 3):
			pass #bluegrils
		if(house == 4):
			pass #wait how does snakes lay eggs when they themselves eat eggs???
