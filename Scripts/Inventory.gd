extends Control


onready var panel = $Panel/VBoxContainer
#onready var _description_label = $ColorRect/Panel/Description
#onready var _ItemContainer = $ColorRect/ItemsContainer

export(PackedScene) var ItemButton

func create_item_button(item):
	var item_button = ItemButton.instance()
	panel.add_child(item_button)
	item_button.UpdateButton(item)
	return item_button

func _on_Player_GrabbedAnItem(item):
	create_item_button(item)
