extends Control


onready var _item_grid = $ColorRect/ItemsContainer/MarginContainer/GridContainer
onready var _description_label = $ColorRect/Panel/Description

export(PackedScene) var ItemButton

func create_item_button(item):
	var item_button = ItemButton.instance()
	item_button.initialize(item)
	return item_button
	
