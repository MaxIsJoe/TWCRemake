extends Node


remotesync func CreateThePlayer(charname,gender,house, loc, locSpawnPos):
	if(gender == 1):
		if(house == 1):
			var NewGrifMale = Data.MaleGryffindor.instance()
			Network.PlayerContainer.add_child(NewGrifMale)
			NewGrifMale.PlayerName = charname
			NewGrifMale.updatenamelabel()
			NewGrifMale.set_network_master(get_tree().get_network_unique_id())
			NewGrifMale.name = str(get_tree().get_network_unique_id())
			#Teleport.Move_To_Scene(loc, NewGrifMale, locSpawnPos)
			Teleport.TeleportPos(NewGrifMale, locSpawnPos)
		if(house == 2):
			var NewHuffMale = Data.MaleHufflepuff.instance()
			Network.PlayerContainer.add_child(NewHuffMale)
			NewHuffMale.PlayerName = charname
			NewHuffMale.updatenamelabel()
			NewHuffMale.set_network_master(get_tree().get_network_unique_id())
			NewHuffMale.name = str(get_tree().get_network_unique_id())
			Teleport.TeleportPos(NewHuffMale, locSpawnPos)
		if(house == 3):
			var NewClawfMale = Data.MaleRavenclaw.instance()
			Network.PlayerContainer.add_child(NewClawfMale)
			NewClawfMale.PlayerName = charname
			NewClawfMale.updatenamelabel()
			NewClawfMale.set_network_master(get_tree().get_network_unique_id())
			NewClawfMale.name = str(get_tree().get_network_unique_id())
			Teleport.TeleportPos(NewClawfMale, locSpawnPos)
		if(house == 4):
			var NewSlythMale = Data.MaleSlytherin.instance()
			Network.PlayerContainer.add_child(NewSlythMale)
			NewSlythMale.PlayerName = charname
			NewSlythMale.updatenamelabel()
			NewSlythMale.set_network_master(get_tree().get_network_unique_id())
			NewSlythMale.name = str(get_tree().get_network_unique_id())
			Teleport.TeleportPos(NewSlythMale, locSpawnPos)
	if(gender == 2):
		if(house == 1):
			var NewGrifFemale = Data.FemaleGryffindor.instance()
			Network.PlayerContainer.add_child(NewGrifFemale)
			NewGrifFemale.PlayerName = charname
			NewGrifFemale.updatenamelabel()
			NewGrifFemale.set_network_master(get_tree().get_network_unique_id())
			NewGrifFemale.name = str(get_tree().get_network_unique_id())
			Teleport.TeleportPos(NewGrifFemale, locSpawnPos)
		if(house == 2):
			var NewHuffFemale = Data.FemaleHufflepuff.instance()
			Network.PlayerContainer.add_child(NewHuffFemale)
			NewHuffFemale.PlayerName = charname
			NewHuffFemale.updatenamelabel()
			NewHuffFemale.set_network_master(get_tree().get_network_unique_id())
			NewHuffFemale.name = str(get_tree().get_network_unique_id())
			Teleport.TeleportPos(NewHuffFemale, locSpawnPos)
		if(house == 3):
			var NewClawFemale = Data.FemaleRavenclaw.instance()
			Network.PlayerContainer.add_child(NewClawFemale)
			NewClawFemale.PlayerName = charname
			NewClawFemale.updatenamelabel()
			NewClawFemale.set_network_master(get_tree().get_network_unique_id())
			NewClawFemale.name = str(get_tree().get_network_unique_id())
			Teleport.TeleportPos(NewClawFemale, locSpawnPos)
		if(house == 4):
			var NewSlythFemale = Data.FemaleSlytherin.instance()
			Network.PlayerContainer.add_child(NewSlythFemale)
			NewSlythFemale.PlayerName = charname
			NewSlythFemale.updatenamelabel()
			NewSlythFemale.set_network_master(get_tree().get_network_unique_id())
			NewSlythFemale.name = str(get_tree().get_network_unique_id())
			Teleport.TeleportPos(NewSlythFemale, locSpawnPos)
