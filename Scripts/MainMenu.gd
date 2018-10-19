extends Control

var version = "0.0.1"
var selecteditem
export (NodePath) var dropdown_path

onready var versionlabel = get_node("MainPage/Version")
onready var charactersetup = get_node("CharacterPage")
onready var mainpage = get_node("MainPage")
onready var dropdown = get_node(dropdown_path)

func _ready():
	versionlabel.text = version
	add_items()

func _on_StartButton_pressed():
	mainpage.visible = false
	charactersetup.visible = true
	
func add_items():
	dropdown.add_item("Wizard")
	dropdown.add_item("Witch")


func _on_FinishCharSetup_pressed():
	var CharacterName = get_node("CharacterPage/SelectName")
	print("The Character's name is" , CharacterName.text, "And their gender is" ,selecteditem)


func _on_SelectGender_item_selected(ID):
	selecteditem = ID


func _on_ExitButiion_pressed():
	get_tree().quit()
