extends Node

##The JSON_LOADER autoload is used to handle loading data from JSON files without having to rewrite the same function over and over again for each use case

func LoadJSON_General(JSONFile, WhereToStore): #Used to pass data to variables that can be accsed globally
	print("[LOAD] file : looking for [%s]..." % JSONFile)
	if FileAccess.file_exists(WhereToStore + JSONFile):
		print("[SUCCSUES] file : [%s] does exist and is loaded." % JSONFile)
		var dfile = FileAccess.open(WhereToStore + JSONFile, FileAccess.READ)
		var test_json_conv = JSON.new()
		test_json_conv.parse(dfile.get_as_text())
		var data = test_json_conv.get_data()
		match WhereToStore:
			0: #Dialouge
				Data.Loaded_Dialouge = data
			1: #Items
				Data.ItemData = data
			2: #Spells
				Data.SpellsData = data
	else:
		print("[ERROR] file : [%s] does not exist or is empty" % JSONFile)

func LoadJSON_Retrun(JSONFile) -> Dictionary:
	print("[LOAD] file : looking for [%s]..." % JSONFile)
	var dfile : FileAccess
	if(FileAccess.file_exists(JSONFile)):
		dfile = FileAccess.open(JSONFile, FileAccess.READ)
		print("[SUCCSUES] file : [%s] does exist and is loaded." % JSONFile)
	else:
		print("[ERROR] file : [%s] does not exist or is empty" % JSONFile)
	var test_json_conv = JSON.new()
	test_json_conv.parse(dfile.get_as_text())
	var data = test_json_conv.get_data()
	return data

func SaveJSON(data, path):
	var file = FileAccess.open(path, FileAccess.WRITE_READ)
	file.store_line(JSON.new().stringify(data))
	file.close()
