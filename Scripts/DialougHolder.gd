extends Node

export(String) var QuickDialougFile
export(String) var Dialogic_Timeline

var loaded_quickdia

func _ready():
	if(QuickDialougFile != ""):
		loaded_quickdia = JsonLoader.LoadJSON_Retrun(QuickDialougFile)

func StartDialogue(timeline):
	var new_dialog
	if(timeline == ""):
		if(Dialogic_Timeline != ""):
			new_dialog = Dialogic.start(Dialogic_Timeline)
		else:
			return
	else:
		new_dialog = Dialogic.start(timeline)
	add_child(new_dialog)
	new_dialog.connect("dialogic_signal", self, 'dialogic_Signals')
	new_dialog.connect('timeline_end', self, 'after_dialog')
	Data.Player.canMove = false
	
func dialogic_Signals(value: String):
	if(value == "shop"):
		Data.Player.ShowShopUI(get_parent().get_node("ShopHolder").ItemIDs, get_parent().get_node("ShopHolder").ShopID)
	if(value == "deposit"):
		Bank.showUI(1)
	if(value == "withdraw"):
		Bank.showUI(0)
	else: #If we're doing function calls that require arguments.
		Global.CheckForFunctionCall(value)
	
func after_dialog(timeline_name):
	Data.Player.canMove = true

func GetQuickDia():
	randomize()
	var token = int(rand_range(0, loaded_quickdia.values().size()))
	var given_text = loaded_quickdia[str(token)].get("text")
	return given_text
