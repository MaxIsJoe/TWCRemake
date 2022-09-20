extends TabBar


@onready var SpellButton = load("res://Scenes/Instances/Actors/UI/buttons/SpellButton.tscn")


func _ready():
	SpawnButton("000")
	SpawnButton("001")

func SpawnButton(Info):
	var Name = Data.SpellsData[Info].get("SpellName")
	var Icon = Data.SpellsData[Info].get("SpellIcon")
	var Action = Data.SpellsData[Info].get("Action")
	var button = SpellButton.instantiate()
	button.UpdateButton(Name,Icon,Info)
	$SpellsContainer/ScrollContainer/GridContainer.add_child(button)
