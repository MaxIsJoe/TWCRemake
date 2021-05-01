extends Node

signal send_text(text)
export(String) var DialougFile
export(String) var QuickDialougFile

var loaded_quickdia

func _ready():
	if(QuickDialougFile != ""):
		loaded_quickdia = JsonLoader.LoadJSON_Retrun(QuickDialougFile)

func StartDialogue():
	#We already have a way to start dialouge so wtf is this?
	pass #Add in later

func GetQuickDia():
	randomize()
	var token = int(rand_range(0, loaded_quickdia.values().size()))
	var given_text = loaded_quickdia[str(token)].get("text")
	return given_text
