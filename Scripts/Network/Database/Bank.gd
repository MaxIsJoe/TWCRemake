extends Node

var banksPath : String = "user://accounts/BanksAndVaults/"

var bankUI : PackedScene = load("res://Scenes/Instances/Actors/UI/BankUI.tscn")

func _ready():
	var dir = Directory.new()
	if(dir.dir_exists(banksPath)):
		pass
	else:
		dir.make_dir(banksPath)

remotesync func desposit(playerKey: String, amount: int, playerNode : PlayerEntity):
	if(doesThisPlayerHaveABankAccount(playerKey)):
		var file
		var dir : Directory = Directory.new()
		if dir.open(banksPath) == OK:
			dir.list_dir_begin(true, true)
			while file != "":
				if(file != null):
					if(file.begins_with(str(playerKey))):
						var dataInFile = JsonLoader.LoadJSON_Retrun(str(banksPath + playerKey + ".json"))
						var dataNewData = {"amount": amount + dataInFile["amount"]}
						playerNode.gold -= amount
						JsonLoader.SaveJSON(dataNewData, str(banksPath + playerKey + ".json"))
						break
				file = dir.get_next()
		else:
			print("[Banks] - Player account not found!")
			
remotesync func howMuchMoneyDoesThisPlayerHave(playerKey: String):
	if(doesThisPlayerHaveABankAccount(playerKey)):
		var file
		var dir : Directory = Directory.new()
		if dir.open(banksPath) == OK:
			dir.list_dir_begin(true, true)
			while file != "":
				if(file != null):
					if(file.begins_with(str(playerKey))):
						var dataInFile = JsonLoader.LoadJSON_Retrun(str(banksPath + playerKey + ".json"))
						return dataInFile["amount"]
						break
				file = dir.get_next()
		else:
			print("[Banks] - Player account not found!")
			return null
			
remotesync func withdraw(playerKey: String, amountToWithdraw: int, playerNode: PlayerEntity):
	if(doesThisPlayerHaveABankAccount(playerKey)):
		var file
		var dir : Directory = Directory.new()
		if dir.open(banksPath) == OK:
			dir.list_dir_begin(true, true)
			while file != "":
				if(file != null):
					if(file.begins_with(str(playerKey))):
						var dataInFile = JsonLoader.LoadJSON_Retrun(str(banksPath + playerKey + ".json"))
						if(amountToWithdraw > dataInFile["amount"]):
							return false
						else:
							playerNode.gold += amountToWithdraw
							var dataNewData = {"amount": (dataInFile["amount"] - amountToWithdraw)}
							JsonLoader.SaveJSON(dataNewData, str(banksPath + playerKey + ".json"))
							return true
						break
				file = dir.get_next()
		else:
			print("[Banks] - Player account not found!")
			return false
	
remotesync func UpdateDialogicBankStatus(playerKey: String):
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

remotesync func registerPlayerAccount(playerKey):
	if(doesThisPlayerHaveABankAccount(playerKey) == false):
		var data = {"amount": 100}
		JsonLoader.SaveJSON(data, str(banksPath + playerKey + ".json"))
	else:
		print("[Banks] - User already has a registered account.")
	
remotesync func doesThisPlayerHaveABankAccount(key):
	var _file : File = File.new()
	if _file.open(str(banksPath + key + ".json"), File.READ) == OK:
		return true
	else:
		print("Failed to find " + banksPath + key + ".json")
		return false

func showUI(mode: int):
	var ui = bankUI.instance()
	add_child(ui)
	ui.ShowUI(mode)
