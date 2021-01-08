extends Control

###The host for now is 100% responsible for all savefiles
###(Max): While in the future I'd like to move to other means of account/savefile managment, this for now will do the job.

export(int, 3, 32) var MiniumPasswordLength = 3

onready var warninglabel = $VBoxContainer/WarningLabel
onready var keyinput = $VBoxContainer/KeyInput
onready var passwordinput = $VBoxContainer/PasswordInput

var keyexists = false

remote func DoesThisKeyExist(key): #Loops through all files in /saves/ to find a filename with the inserted key.
	var file
	var dir = Directory.new()
	if dir.open("user://accounts/") == OK:
		dir.list_dir_begin(true, true)
		while file != "": #(Max): I have no idea what's going on here but it works so I'm not messing with it.
			if(file != null):
				if(file.begins_with(str(key))): 
					rset_id(get_tree().get_rpc_sender_id(), "keyexists", true) #Tell the client that his account does exist
					break #(Max): Does this even stop the loop?
			file = dir.get_next()
	else:
		print("Failed to open user://accounts/")

remote func getpassword(savefile, password, id): #Gets the password from a savefile
	var file = File.new()
	file.open(str("user://accounts/" + savefile + ".json"), File.READ)
	var dfile = file.get_as_text()
	var data = parse_json(dfile) #store it in a dictionary so we can call data.get("password")
	var pw = passwordhasing(password)
	file.close()
	if(data.get("password") == pw):
		rpc_id(id, "startgame", savefile)
	else:
		rpc_id(id, "UpdateLabelRemotly", "Incorrect key or password.")

remote func createaccount(key, password, id):
	var pw = {"password": passwordhasing(passwordinput.text)}
	JsonLoader.SaveJSON(pw, str("user://accounts/" + key + ".json"))
	rpc_id(id, "startgame", key)

remote func startgame(key):
	Data.main_node.LoadGame()
	GiveUserHisKey(key)

remote func UpdateLabelRemotly(txt): #Updates the warning label remotely
	warninglabel.text = txt

remote func GiveUserHisKey(k):
	Data.main_node.key = k

func passwordhasing(password:String):
	var final = password.sha256_text() 
	return final

###(Max): Note to self or anyone working on this, rename Button and Button2 and Button3 to something else
###(Max): I'd do it now but I'm too lazy to do it so I'm instead going to write a lengthy comment about it
func _on_Button_button_down():
	if(keyinput.text == "" or str(passwordinput.text).length() < MiniumPasswordLength):
		warninglabel.text = "Invalid data entered."
		return
	rpc_id(1, "DoesThisKeyExist", keyinput.text)
	if(keyexists):
		rpc_id(1, "getpassword", keyinput.text, passwordinput.text, get_tree().get_network_unique_id())
	else:
		warninglabel.text = "Incorrect key or password."


func _on_Button2_button_down():
	if(keyinput.text == "" or str(passwordinput.text).length() < MiniumPasswordLength):
		warninglabel.text = "Invalid data entered."
		return
	rpc_id(1, "DoesThisKeyExist", keyinput.text)
	if(keyexists):
		warninglabel.text = "Key already exists."
	else:
		rpc_id(1, "createaccount", keyinput.text, passwordinput.text, get_tree().get_network_unique_id())
		

func _on_Button3_button_down():
	randomize()
	var randomkey = int(rand_range(-100000,100000)) #(Max): Too simple for my liking, I'll remember to add a task in my to-do list to create a complex random key generator that's complicated for no reason.
	keyinput.secret = false
	keyinput.text = str(randomkey)
