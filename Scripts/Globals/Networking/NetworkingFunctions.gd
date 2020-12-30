extends Node


remotesync func CreateThePlayer(charname,gender,house, loc, locSpawnPos, network_id):
	if(Network.PlayerContainer.has_node(str(network_id)) or charname == null): #To (hopefully) prevent the game from creating millions of copies of the same player.
		return
	else:
		if(gender == 0):
			if(house == 0):
				var NewGrifMale = Data.MaleGryffindor.instance()
				if(network_id == null): NewGrifMale.name = str(get_tree().get_network_unique_id()); else: NewGrifMale.name = str(network_id)
				NewGrifMale.set_network_master(network_id)
				Network.PlayerContainer.add_child(NewGrifMale)
				NewGrifMale.PlayerName = charname
				NewGrifMale.updatenamelabel()
				#Teleport.Move_To_Scene(loc, NewGrifMale, locSpawnPos)
				Teleport.TeleportPos(NewGrifMale, locSpawnPos)
			if(house == 1):
				var NewHuffMale = Data.MaleHufflepuff.instance()
				if(network_id == null): NewHuffMale.name = str(get_tree().get_network_unique_id()); else: NewHuffMale.name = str(network_id)
				NewHuffMale.set_network_master(network_id)
				Network.PlayerContainer.add_child(NewHuffMale)
				NewHuffMale.PlayerName = charname
				NewHuffMale.updatenamelabel()
				Teleport.TeleportPos(NewHuffMale, locSpawnPos)
			if(house == 2):
				var NewClawfMale = Data.MaleRavenclaw.instance()
				if(network_id == null): NewClawfMale.name = str(get_tree().get_network_unique_id()); else: NewClawfMale.name = str(network_id)
				NewClawfMale.set_network_master(network_id)
				Network.PlayerContainer.add_child(NewClawfMale)
				NewClawfMale.PlayerName = charname
				NewClawfMale.updatenamelabel()
				Teleport.TeleportPos(NewClawfMale, locSpawnPos)
			if(house == 3):
				var NewSlythMale = Data.MaleSlytherin.instance()
				if(network_id == null): NewSlythMale.name = str(get_tree().get_network_unique_id()); else: NewSlythMale.name = str(network_id)
				NewSlythMale.set_network_master(network_id)
				Network.PlayerContainer.add_child(NewSlythMale)
				NewSlythMale.PlayerName = charname
				NewSlythMale.updatenamelabel()
				Teleport.TeleportPos(NewSlythMale, locSpawnPos)
		if(gender == 1):
			if(house == 0):
				var NewGrifFemale = Data.FemaleGryffindor.instance()
				if(network_id == null): NewGrifFemale.name = str(get_tree().get_network_unique_id()); else: NewGrifFemale.name = str(network_id)
				NewGrifFemale.set_network_master(network_id)
				Network.PlayerContainer.add_child(NewGrifFemale)
				NewGrifFemale.PlayerName = charname
				NewGrifFemale.updatenamelabel()
				Teleport.TeleportPos(NewGrifFemale, locSpawnPos)
			if(house == 1):
				var NewHuffFemale = Data.FemaleHufflepuff.instance()
				if(network_id == null): NewHuffFemale.name = str(get_tree().get_network_unique_id()); else: NewHuffFemale.name = str(network_id)
				NewHuffFemale.set_network_master(network_id)
				Network.PlayerContainer.add_child(NewHuffFemale)
				NewHuffFemale.PlayerName = charname
				NewHuffFemale.updatenamelabel()
				Teleport.TeleportPos(NewHuffFemale, locSpawnPos)
			if(house == 2):
				var NewClawFemale = Data.FemaleRavenclaw.instance()
				if(network_id == null): NewClawFemale.name = str(get_tree().get_network_unique_id()); else: NewClawFemale.name = str(network_id)
				NewClawFemale.set_network_master(network_id)
				Network.PlayerContainer.add_child(NewClawFemale)
				NewClawFemale.PlayerName = charname
				NewClawFemale.updatenamelabel()
				Teleport.TeleportPos(NewClawFemale, locSpawnPos)
			if(house == 3):
				var NewSlythFemale = Data.FemaleSlytherin.instance()
				NewSlythFemale.set_network_master(network_id)
				if(network_id == null): NewSlythFemale.name = str(get_tree().get_network_unique_id()); else: NewSlythFemale.name = str(network_id)
				Network.PlayerContainer.add_child(NewSlythFemale)
				NewSlythFemale.PlayerName = charname
				NewSlythFemale.updatenamelabel()
				Teleport.TeleportPos(NewSlythFemale, locSpawnPos)

remotesync func RemovePlayerFromWorld(id):
	var target = Network.PlayerContainer.get_node(str(id))
	target.queue_free()
