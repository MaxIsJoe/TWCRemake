extends Control


onready var panel = $Panel/VBoxContainer
#onready var _description_label = $ColorRect/Panel/Description
#onready var _ItemContainer = $ColorRect/ItemsContainer

export(PackedScene) var ItemButton

var ButtonIDs = -1

func create_item_button(item):
	ButtonIDs += 1
	var item_button = ItemButton.instance()
	panel.add_child(item_button)
	item_button.UpdateButton(item, ButtonIDs)
	return item_button

func _on_Player_GrabbedAnItem(item):
	create_item_button(item)
