extends Node


remotesync func CreateThePlayer(charname,gender,house, loc, locSpawnPos, network_id):
		if(Global.DEBUG_Mode):
			print("Creating character for ", network_id)
			print("[NetworkFunc/CreateThePlayer] - RPC Sender ID ->", get_tree().get_rpc_sender_id())
			print("[NetworkFunc/CreateThePlayer] - charname is ->", charname)
		
		var player = Data.PlayerBase.instance()
		player.set_network_master(network_id)
		if(network_id == null): 
			player.name = str(get_tree().get_network_unique_id()) 
		else: 
			player.name = str(network_id)
		NetworkManager.Network.PlayerContainer.add_child(player)
		player.SetupPlayer(house, charname, gender)
		Teleport.TeleportPos(player, locSpawnPos, null)

remotesync func RemovePlayerFromWorld(id):
	var target = NetworkManager.Network.PlayerContainer.get_node(str(id))
	if(target != null): target.queue_free()
