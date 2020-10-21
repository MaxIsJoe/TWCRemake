extends Node

signal send_text(text)
export(String) var DialougFile
export(String) var QuickDialougFile

func GetQuickDia():
	randomize()
	var token = rand_range(0, QuickDialougFile.SpokenLines.size())
	var given_text = QuickDialougFile.SpokenLines[token]
	print(QuickDialougFile.SpokenLines)
	emit_signal("send_text", given_text)
