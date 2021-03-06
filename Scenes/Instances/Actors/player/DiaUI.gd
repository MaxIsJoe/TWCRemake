extends Control

onready var DiaUI = self
onready var DiaBackground = $Background
onready var DiaText = $Background/DialogueText
onready var DiaChoicesHolder = $Background/Choices/ChoicesHolder

onready var ButtonPrefap = preload("res://Scenes/Instances/Actors/UI/buttons/ChoiceButton.tscn")

export(float) var interpolateTime = 0.4
var CanFlip = false
var revealspd = 35
var CurrentID
var IsVisible = false

signal StartDialougRemotely(FILE, ID)


func _input(event):
	if(CanFlip):
		if(Input.is_action_just_pressed("ui_accept")):
			$Tween.stop_all()
			var nextID = Data.Loaded_Dialouge[CurrentID].get("next")
			if(Data.Loaded_Dialouge[CurrentID].get("type") == "dialouge"):
				if(Data.Loaded_Dialouge[CurrentID].get("next") != ""):
					Dia_SetText(nextID)
					CurrentID = nextID
			if(Data.Loaded_Dialouge[CurrentID].get("type") == "response"):
					Dia_LoadChoices(CurrentID)
					CanFlip = false
			if(Data.Loaded_Dialouge[CurrentID].get("next") == ""):
					ShowUI(false)
					CanFlip = false

func ShowUI(check:bool):
	if(!visible):
		visible = true
	if(check):
		$TweenVisibility.interpolate_property(DiaBackground, "modulate", Color(1,1,1,0), Color(1,1,1,1), interpolateTime, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		$TweenVisibility.start()
	else:
		$TweenVisibility.interpolate_property(DiaBackground, "modulate", Color(1,1,1,1), Color(1,1,1,0), interpolateTime, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		$TweenVisibility.start()
		

func Dia_init(ID):
	CurrentID = ID
	if(!visible):
		ShowUI(true)
	CanFlip = true
	Dia_SetText(ID)
	

func Dia_SetText(ID):
	if(Data.Loaded_Dialouge[ID].has("cond")):
		if(Global.ConditionCheck(ID)):
			pass
		else:
			return
	if(ID == ""):
		CanFlip = false
		ShowUI(false)
		return
	DiaText.bbcode_text = str(Data.Loaded_Dialouge[ID].get("text"))
	
	if("[gender]" in DiaText.bbcode_text):
		if(Data.Player.Gender == 1):
			var newtext = DiaText.bbcode_text.replace("[gender]", "Madam")
			DiaText.bbcode_text = str(newtext)
		else:
			var newtext = DiaText.bbcode_text.replace("[gender]", "Sir")
			DiaText.bbcode_text = str(newtext)
	if("[playername]" in DiaText.bbcode_text):
			var newtext = DiaText.bbcode_text.replace("[playername]", str("[color=cyan]" + Data.Player.PlayerName + "[/color]"))
			DiaText.bbcode_text = str(newtext)
	
	Dia_TypeWriter()
	#if(Data.Loaded_Dialouge[ID].has("speaker")):
		#DiaNamesUI.bbcode_text = str(Data.Loaded_Dialouge[ID].get("speaker"))
		#$DiaHolder/NamesUI.visible = true
	#else:
	#	$DiaHolder/NamesUI.visible = false
	if(Data.Loaded_Dialouge[ID].has("func")):
		CheckForFunctions(ID)

func Dia_LoadChoices(ID):
	var keys = Data.Loaded_Dialouge[ID].get("choices")
	for key in keys:
		var s = ButtonPrefap.instance()
		s.InitlizeButtonName(key)
		s.InitlizeButtonID(keys[key].get("next"))
		DiaChoicesHolder.add_child(s)
		print(keys[key].get("next"))
	
func Dia_TypeWriter():
	DiaText.percent_visible = 0
	var time = DiaText.bbcode_text.length() / revealspd
	$Tween.interpolate_property(DiaText, "percent_visible", 0, 1, time, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.start()

func ToggleVisbility():
	if(visible):
		visible = false
	else:
		visible = true

func CheckForFunctions(ID):
	print(Data.Loaded_Dialouge[CurrentID].get("func"))
	Global.CheckForFunctionCall(Data.Loaded_Dialouge[ID].get("func"))


func _on_DiaUI_StartDialougRemotely(FILE, ID):
	if(FILE == null):
		Dia_SetText(ID)
		CurrentID = ID
		CanFlip = true
	else:
		JsonLoader.LoadJSON_General(FILE, 0)
		Dia_init(ID)
		
func ClearChoices():
	var childern = $Background/Choices/ChoicesHolder.get_children()
	for child in childern:
		$Background/Choices/ChoicesHolder.remove_child(child)


func _on_TweenVisibility_tween_completed(object, key):
	if(IsVisible):
		visible = false
		IsVisible = false
	else:
		IsVisible = true
