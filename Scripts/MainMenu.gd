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

#Here we define where new players will load into and where their position will be.
var DiagonAlley = "res://Scenes/Levels/DiagonAlley.tscn"
var DiagonAlleySpawnPos = Vector2(782,177)

export (NodePath) var dropdown_path

#All the importat things that needs to referenced and defined
onready var versionlabel = get_node("MainPage/Version")
onready var charactersetup = get_node("CharacterPage")
onready var mainpage = get_node("MainPage")
onready var dropdownGender = get_node("CharacterPage/SelectGender")
onready var dropdownHouse = get_node("CharacterPage/SelectHouse")
onready var warninglabel = get_node("CharacterPage/Warning")
var MaleGryffindor = preload("res://Scenes/Instances/Actors/Houses/GrifMale.tscn")
var MaleHufflepuff = preload("res://Scenes/Instances/Actors/Houses/MaleHuff.tscn")
var MaleRavenclaw = preload("res://Scenes/Instances/Actors/Houses/MaleClaw.tscn")
var MaleSlytherin = preload("res://Scenes/Instances/Actors/Houses/SlythMale.tscn")
var FemaleGryffindor = preload("res://Scenes/Instances/Actors/Houses/GrifFemale.tscn")
var FemaleHufflepuff = preload("res://Scenes/Instances/Actors/Houses/FemaleHuff.tscn")
var FemaleRavenclaw = preload("res://Scenes/Instances/Actors/Houses/FemaleClaw.tscn")
var FemaleSlytherin  = preload("res://Scenes/Instances/Actors/Houses/SlythFemale.tscn")

func _ready():
	versionlabel.text = version
	add_items() #Adds items to the drop down menu to be used
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
	print("The Character's name is" , CharacterName.text, "And their gender is" ,selecteditemG)
	#Check if the player has filled everything in correctly
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
	
remote func CreateThePlayer(charname,gender,house):
	if(gender == 1):
		if(house == 1):
			var NewGrifMale = MaleGryffindor.instance()
			add_child(NewGrifMale)
			NewGrifMale.PlayerName = charname.text
			NewGrifMale.updatenamelabel()
			NewGrifMale.set_network_master(get_tree().get_network_unique_id())
			Teleport.Move_To_Scene(DiagonAlley, NewGrifMale, DiagonAlleySpawnPos)
		if(house == 2):
			var NewHuffMale = MaleHufflepuff.instance()
			add_child(NewHuffMale)
			NewHuffMale.PlayerName = charname.text
			NewHuffMale.updatenamelabel()
			NewHuffMale.set_network_master(get_tree().get_network_unique_id())
			Teleport.Move_To_Scene(DiagonAlley, NewHuffMale, DiagonAlleySpawnPos)
		if(house == 3):
			var NewClawfMale = MaleRavenclaw.instance()
			add_child(NewClawfMale)
			NewClawfMale.PlayerName = charname.text
			NewClawfMale.updatenamelabel()
			NewClawfMale.set_network_master(get_tree().get_network_unique_id())
			Teleport.Move_To_Scene(DiagonAlley, NewClawfMale, DiagonAlleySpawnPos)
		if(house == 4):
			var NewSlythMale = MaleSlytherin.instance()
			add_child(NewSlythMale)
			NewSlythMale.PlayerName = charname.text
			NewSlythMale.updatenamelabel()
			NewSlythMale.set_network_master(get_tree().get_network_unique_id())
			Teleport.Move_To_Scene(DiagonAlley, NewSlythMale, DiagonAlleySpawnPos)
	if(gender == 2):
		if(house == 1):
			var NewGrifFemale = FemaleGryffindor.instance()
			add_child(NewGrifFemale)
			NewGrifFemale.PlayerName = charname.text
			NewGrifFemale.updatenamelabel()
			NewGrifFemale.set_network_master(get_tree().get_network_unique_id())
			Teleport.Move_To_Scene(DiagonAlley, NewGrifFemale, DiagonAlleySpawnPos)
		if(house == 2):
			var NewHuffFemale = FemaleHufflepuff.instance()
			add_child(NewHuffFemale)
			NewHuffFemale.PlayerName = charname.text
			NewHuffFemale.updatenamelabel()
			NewHuffFemale.set_network_master(get_tree().get_network_unique_id())
			Teleport.Move_To_Scene(DiagonAlley, NewHuffFemale, DiagonAlleySpawnPos)
		if(house == 3):
			var NewClawFemale = FemaleRavenclaw.instance()
			add_child(NewClawFemale)
			NewClawFemale.PlayerName = charname.text
			NewClawFemale.updatenamelabel()
			NewClawFemale.set_network_master(get_tree().get_network_unique_id())
			Teleport.Move_To_Scene(DiagonAlley, NewClawFemale, DiagonAlleySpawnPos)
		if(house == 4):
			var NewSlythFemale = FemaleSlytherin.instance()
			add_child(NewSlythFemale)
			NewSlythFemale.PlayerName = charname.text
			NewSlythFemale.updatenamelabel()
			NewSlythFemale.set_network_master(get_tree().get_network_unique_id())
			#Move_To_Next_Scene(thisscene ,nextscene, player,spawnPos):
			#NewSlythFemale.Move_To_Next_Scene(self, TestWorld, NewSlythFemale, TestWorldSpawnPostion)
			Teleport.Move_To_Scene(DiagonAlley, NewSlythFemale, DiagonAlleySpawnPos)
