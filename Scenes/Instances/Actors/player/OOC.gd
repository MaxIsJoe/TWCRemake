extends Tabs

var m = ""

func _ready():
	Network.connect("chat_message_received", self, "add_chat_line")

func add_chat_line(msg):
	$RichTextLabelOOC.add_text(msg)
	$RichTextLabelOOC.newline()
	if (get_tree().is_network_server()):
			Network.send_message(1, m)
	else:
			Network.rpc_id(1, "send_message", get_tree().get_network_unique_id(), m, true)


func _on_TextEditOOC_text_changed():
	m = $TextEditOOC.text
	
func _input(event):
	if(Input.is_action_just_pressed("ui_accept")):
		if(m == ""):
			return
		m.strip_edges()
		add_chat_line(m)
		$TextEditOOC.text = ""
