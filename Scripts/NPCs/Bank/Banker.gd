extends MobEnity_NPC


func _ready():
	#This is the only way I managed to get this working unfortuntly
	#Grouping them all in one sprite then randomly picking frames doesn't work
	randomize()
	var spriteToChoose = int(rand_range(1,3))
	match spriteToChoose:
		1:
			SpriteHandler.PlayAnim("1", $SpriteHandler/Body)
		2:
			SpriteHandler.PlayAnim("2", $SpriteHandler/Body)
		3:
			SpriteHandler.PlayAnim("3", $SpriteHandler/Body)
			

func _on_NPCBase_input_event(viewport, event, shape_idx):
	._on_NPCBase_input_event(viewport, event, shape_idx)
	if event is InputEventMouseButton:
		var distance2player = Global.GetDistance2Player(self)
		if(distance2player <= InteractionDistance):
			if event.button_index == BUTTON_LEFT and event.pressed:
				talkToBanker()

func talkToBanker():
	if(Bank.doesThisPlayerHaveABankAccount(Data.main_node.key)):
		var new_dialog = Dialogic.start('Banker_Talk')
		add_child(new_dialog)
		Bank.registerPlayerAccount(Data.main_node.key)
		Bank.UpdateDialogicBankStatus(Data.main_node.key)
	else:
		var new_dialog = Dialogic.start('Banker_FirstMeet')
		add_child(new_dialog)
		Bank.UpdateDialogicBankStatus(Data.main_node.key)
	Global.UpdateDialogicPlayerDataVariables()
	
