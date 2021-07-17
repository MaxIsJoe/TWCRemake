extends Node

var banksPath : String = "user://database/BanksAndVaults/"


func _ready():
	var dir = Directory.new()
	if(dir.dir_exists(banksPath)):
		pass
	else:
		dir.make_dir(banksPath)

func desposit(playerKey: String, amount: int):
	if(doesThisPlayerHaveABankAccount(playerKey)):
		var file
		var dir : Directory = Directory.new()
		if dir.open(banksPath) == OK:
			dir.list_dir_begin(true, true)
			while file != "":
				if(file != null):
					if(file.begins_with(str(playerKey))): 
						var data = {"amount": amount}
						JsonLoader.SaveJSON(data, str(banksPath + playerKey + ".json"))
						break
				file = dir.get_next()
		else:
			print("[Banks] - Player account not found!")
			
func withdraw(playerKey: String, amount: int, playerNode):
	pass
	
func UpdateDialogicBankStatus(playerKey: String):
	if(doesThisPlayerHaveABankAccount(playerKey)):
		var file
		var dir : Directory = Directory.new()
		if dir.open(banksPath) == OK:
			dir.list_dir_begin(true, true)
			while file != "":
				if(file != null):
					if(file.begins_with(str(playerKey))):
						var data = JsonLoader.LoadJSON_Retrun(str(banksPath + playerKey + ".json"))
						if(data != null):
							print("[Bank] - Current money for " + playerKey + " is " + str(data["amount"]))
							Dialogic.set_variable("PlayerBankMoney", data["amount"])
						else:
							print("[Error/Bank] - JSON data failed to load correctly.")
						return
				file = dir.get_next()
		else:
			print("[Banks] - Player account not found!")

func registerPlayerAccount(playerKey):
	if(doesThisPlayerHaveABankAccount(playerKey) == false):
		var data = {"amount": 100}
		JsonLoader.SaveJSON(data, str(banksPath + playerKey))
		return true
	else:
		print("[Banks] - User already has a registered account.")
		return false
	
func doesThisPlayerHaveABankAccount(key):
	var file
	var dir : Directory = Directory.new()
	if dir.open(banksPath) == OK:
		dir.list_dir_begin(true, true)
		while file != "":
			if(file != null):
				if(file.begins_with(str(key))): 
					return true
			file = dir.get_next()
		return false
	else:
		print("Failed to open " + banksPath)
		return false
