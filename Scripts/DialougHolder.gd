extends Node

signal send_text(text)

var RandomDialoug_Ollivander = ["Now where did I leave that box?",
"Hmm..",
"It's quite today, isn't it?",
"20, 27, 31, still remember every costumer who entered this shop.",
"Sometimes.. I dream of cheese.",
"I used to be a great wizard like you until.. nevermind."]

var RandomEmotes_Ollivander = ["*Sigh*", "*Humms a song*"]

func QuickDialoug():
	if(get_parent().get_parent().NPC_Name == "Olivander"):
		print(RandomDialoug_Ollivander[4])
		print("Changing text.. hopefully")
		randomize()
		var luck = floor(rand_range(1,2))
		var dialougoptions = floor(rand_range(0,5))
		var emoteoptions = floor(rand_range(0,1))
		if(luck == 1):
			emit_signal("send_text",RandomDialoug_Ollivander[dialougoptions])
		if(luck == 2):
			emit_signal("send_text",RandomEmotes_Ollivander[emoteoptions])