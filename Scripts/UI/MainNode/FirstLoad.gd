extends Control


func _on_Connect_LAN_button_down():
	NetworkManager.Network.connect_to_server("")
	


func _on_StartSinglePlayer_button_down():
	NetworkManager.Network.create_server()
	Data.main_node.ShowLoginScreen()



func _on_Connect_CustomIp_button_down():
	var IPAddress = $StartupSettings/HBoxContainer2/IP_Text
	if(IPAddress.text != ""):
		NetworkManager.Network.connect_to_server(IPAddress.text)
	else:
		IPAddress.text = "gib me ip pls"
