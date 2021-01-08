extends Node

##The JSON_LOADER autoload is used to handle loading data from JSON files without having to rewrite the same function over and over again for each use case

func LoadJSON_General(JSONFile, WhereToStore): #Used to pass data to variables that can be accsed globally
	print("[LOAD] file : looking for [%s]..." % JSONFile)
	var file = File.new()
	var dfile = file.open(JSONFile, File.READ)
	if(dfile == OK):
		print("[SUCCSUES] file : [%s] does exist and is loaded." % JSONFile)
		dfile = file.get_as_text()
		var data = parse_json(dfile)
		match WhereToStore:
			0: #Dialouge
				Data.Loaded_Dialouge = data
			1: #Items
				Data.ItemData = data
			2: #Spells
				Data.SpellsData = data
		file.close()
	else:
		file.close()
		print("[ERROR] file : [%s] does not exist or is empty" % JSONFile)

func LoadJSON_Retrun(JSONFile) -> Dictionary:
	print("[LOAD] file : looking for [%s]..." % JSONFile)
	var file = File.new()
	var dfile = file.open(JSONFile, File.READ)
	if(dfile == OK):
		print("[SUCCSUES] file : [%s] does exist and is loaded." % JSONFile)
	else:
		file.close()
		print("[ERROR] file : [%s] does not exist or is empty" % JSONFile)
	dfile = file.get_as_text()
	var data = parse_json(dfile)
	return data

func SaveJSON(data, path):
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_line(to_json(data))
	file.close()
