extends Control

onready var ItemButton = load("res://Scenes/Instances/Actors/UI/buttons/SellItemButton.tscn")

export(float) var interpolateTime = 0.8
var IsVisible = false


func OpenShop(ItemsList, ShopID):
	if(ItemsList == null):
		for shop in Data.Group_ShopHolders:
			if(ShopID == shop.ShopID):
				LoadItems(shop.ItemIDs)
				ShowUI(true)
	else:
		LoadItems(ItemsList)
		ShowUI(true)


func _input(event):
	if(visible):
		if(Input.is_action_just_pressed("ui_cancel")):
			ShowUI(false)

func ShowUI(check:bool):
	if(!visible):
		visible = true
	if(check):
		$TweenVisbility.interpolate_property(self, "modulate", Color(1,1,1,0), Color(1,1,1,1), interpolateTime, Tween.TRANS_CUBIC,Tween.EASE_IN_OUT)
		$TweenVisbility.start()
	else:
		$TweenVisbility.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), interpolateTime, Tween.TRANS_CUBIC,Tween.EASE_IN_OUT)
		$TweenVisbility.start()

func LoadItems(ItemsList:Array):
	for item in ItemsList:
		var button = ItemButton.instance()
		button.LoadData(item)
		$Background/ItemShowcase/ScrollContainer/VBoxContainer.add_child(button)
		
func ClearItems():
	var children = $Background/ItemShowcase/ScrollContainer/VBoxContainer.get_children()
	for child in children:
		child.queue_free()


func _on_TweenVisbility_tween_completed(object, key):
	if(IsVisible):
		visible = false
		IsVisible = false
		ClearItems()
	else:
		IsVisible = true

