extends Control

var version = "0.0.1"
var selecteditem
export (NodePath) var dropdown_path

onready var versionlabel = get_node("MainPage/Version")
onready var charactersetup = get_node("CharacterPage")
onready var mainpage = get_node("MainPage")
onready var dropdown = get_node(dropdown_path)
onready var warninglabel = get_node("CharacterPage/Warning")

func _ready():
	versionlabel.text = version
	add_items()
	disable_items(0)
	selecteditem = 0

func _on_StartButton_pressed():
	mainpage.visible = false
	charactersetup.visible = true
	
func add_items():
	dropdown.add_item("Select your gender")
	dropdown.add_item("Wizard")
	dropdown.add_item("Witch")

func disable_items(id):
	dropdown.set_item_disabled(id, true)


func _on_FinishCharSetup_pressed():
	warninglabel.text = ""
	var CharacterName = get_node("CharacterPage/SelectName")
	#print("The Character's name is" , CharacterName.text, "And their gender is" ,selecteditem)
	if(CharacterName.text.length() < 3):
		warninglabel.text = "Please enter a name longer than three characters"
		return
	if(selecteditem == 0 or null):
		warninglabel.text = "Please select your character's gender"
		return
	#Spawn the player with their name and gender assigned to them
		

func _on_SelectGender_item_selected(ID):
	selecteditem = ID


func _on_ExitButiion_pressed():
	get_tree().quit()
