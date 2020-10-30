extends Node

var ScrollIDs = -1


#Singalton functions
func UpdateScrollIDs():
	ScrollIDs += 1
	return ScrollIDs


##Item Functions
func Eat(Regen):
	var value = Regen.split(" ")
	Data.Player.healthregen(int(value[1]))

func OpenScroll(scrollID):
	Data.Player.ShowScroll(scrollID)
