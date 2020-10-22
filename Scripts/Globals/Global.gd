extends Node

#House Points
var GrifPoints = 0
var SlythPoints = 0
var ClawPoints = 0
var HuffPoints = 0


var housewinnerofthismonth

var housenames = ["Grif","Slyth","Claw","Huff"]

var day = OS.get_date()["day"]
var Moon
var DaynNight

var NightColor = Color(0, 0.06, 0.45, 0.35)
var DayColor = Color(7, 33, 203, 0)

func _ready():
	JsonLoader.LoadJSON_General(Data.ItemJSON, 1)

func givepoints(points, to_house):
	if(to_house == "Grif"):
		GrifPoints += points
	elif(to_house == "Slyth"):
		SlythPoints += points
	elif(to_house == "Huff"):
		HuffPoints += points
	elif(to_house == "Claw"):
		ClawPoints += points

func takepoints(points, from_house):
	if(from_house == "Grif"):
		GrifPoints -= points
	elif(from_house == "Slyth"):
		SlythPoints -= points
	elif(from_house == "Huff"):
		HuffPoints -= points
	elif(from_house == "Claw"):
		ClawPoints -= points
		
func GiveHouseCup():
	var points = [GrifPoints, SlythPoints, ClawPoints, HuffPoints] #stores all variables in a array to be quick
	var winner = max(0, points) #the winner has more points than zero and is greater that all other points
	for i in range(0,points.size()): #checks for a winner with the greatest points
		if (winner == points[i]):
			housewinnerofthismonth = housenames[i] #the winner is the same index in both points and houses array
			break #stops the loop once it finds a winner



#Updates

func _process(delta):
	day = OS.get_date()["day"]
	if(day == 1): #on the 1th of each month the house cup will be given to the house with most points, this has been updated because of leap year issues.
		GiveHouseCup()
