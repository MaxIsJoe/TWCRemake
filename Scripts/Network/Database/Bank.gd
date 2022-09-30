extends Node

var banksPath : String = "user://accounts/BanksAndVaults/"

var bankUI : PackedScene = load("res://Scenes/Instances/Actors/UI/BankUI.tscn")

func _ready():
	var dir = FileAccess.open(banksPath, FileAccess.READ)
	if(dir is OK):
		pass
	else:
		dir.make_dir(banksPath)

@rpc(any_peer, call_local) func desposit(playerKey: String, amount: int, playerNode):
	if(doesThisPlayerHaveABankAccount(playerKey)):
		var file
		var dir = FileAccess.open(banksPath, FileAccess.READ)
		if dir == OK:
			dir.list_dir_begin() # TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
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
			
@rpc(any_peer, call_local) func howMuchMoneyDoesThisPlayerHave(playerKey: String):
	if(doesThisPlayerHaveABankAccount(playerKey)):
		var file
		var dir = FileAccess.open(banksPath, FileAccess.READ)
		if dir == OK:
			dir.list_dir_begin() # TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
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
			
@rpc(any_peer, call_local) func withdraw(playerKey: String, amountToWithdraw: int, playerNode):
	if(doesThisPlayerHaveABankAccount(playerKey)):
		var file
		var dir = FileAccess.open(banksPath, FileAccess.READ)
		if dir == OK:
			dir.list_dir_begin() # TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
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
	
@rpc(any_peer, call_local) func UpdateDialogicBankStatus(playerKey: String):
	if(doesThisPlayerHaveABankAccount(playerKey)):
		var file
		var dir = FileAccess.open(banksPath, FileAccess.READ)
		if dir == OK:
			dir.list_dir_begin() # TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
			while file != "":
				if(file != null):
					if(file.begins_with(str(playerKey))):
						var data = JsonLoader.LoadJSON_Retrun(str(banksPath + playerKey + ".json"))
						if(data != null):
							print("[Bank] - Current money for " + playerKey + " is " + str(data["amount"]))
							#Dialogic.set_variable("PlayerBankMoney", data["amount"])
						else:
							print("[Error/Bank] - JSON data failed to load correctly.")
						return
				file = dir.get_next()
		else:
			print("[Banks] - Player account not found!")

@rpc(any_peer, call_local) func registerPlayerAccount(playerKey):
	if(doesThisPlayerHaveABankAccount(playerKey) == false):
		var data = {"amount": 100}
		JsonLoader.SaveJSON(data, str(banksPath + playerKey + ".json"))
	else:
		print("[Banks] - User already has a registered account.")
	
@rpc(any_peer, call_local) func doesThisPlayerHaveABankAccount(key):
	var file = FileAccess.open(str(banksPath + key + ".json"), FileAccess.READ)
	if file == OK:
		return true
	else:
		print("Failed to find " + banksPath + key + ".json")
		return false

func showUI(mode: int):
	var ui = bankUI.instantiate()
	add_child(ui)
	ui.ShowUI(mode)
