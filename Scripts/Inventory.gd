extends Control


onready var _item_grid = $ColorRect/ItemsContainer/MarginContainer/GridContainer
onready var _description_label = $ColorRect/Panel/Description
onready var _ItemContainer = $ColorRect/ItemsContainer

export(PackedScene) var ItemButton

func create_item_button(item):
	var item_button = ItemButton.instance()
	_ItemContainer.add_child(item_button)
	return item_button