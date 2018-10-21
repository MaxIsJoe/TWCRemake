extends Control


onready var _item_grid = $ColorRect/ItemsContainer/MarginContainer/GridContainer
onready var _description_label = $ColorRect/Panel/Description



export(PackedScene) var ItemButton

var inventoryindex = []

signal InventoryChanged

func create_item_button(item):
	var item_button = ItemButton.instance()
	item_button.initialize(item)
	return item_button

func grab(item):
	var grabbeditem = item
	inventoryindex.append(grabbeditem)
	create_item_button(grabbeditem)


func use(item, player):
	item.use(player)
	emit_signal("InventoryChanged")
	
func _ready():
	grab("res://Scenes/Instances/Items/Wands/ElderWand.tres") #Testing