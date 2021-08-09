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

#Day and Night stuff
var DaynNight
var NightColor = Color(0, 0.06, 0.45, 0.35)
var DayColor = Color(7, 33, 203, 0)

#Misc variables
var DEBUG_Mode      : bool = true
var version         : String= "0.0.1"
var EnableFOV       : bool = false
var EnableFPSTracker: bool = true
var PeacefulMode    : bool = false

func _ready():
	yield(get_tree(), "idle_frame")
	JsonLoader.LoadJSON_General(Data.ItemJSON, 1)
	JsonLoader.LoadJSON_General(Data.SpellsJSON, 2)

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

func GetDistance2Player(target):
	if(target == null):
		push_error("[Global/GetDistance2Player] - Target is null!")
		return null
	var distance2player = target.global_position.distance_to(Data.Player.global_position)
	return distance2player
	

#Player/Client specfic
func LoadDialouge(DiaFile, ID):
	Data.UpdateDiaNodeVar()
	for p in Data.Group_DiaNode:
		p.emit_signal("StartDialougRemotely", DiaFile, ID)

func CheckForFunctionCall(FunctionName):
	if(FunctionName.begins_with("GiveGold")):
		var value = FunctionName.split(" ")
		Data.Player.emit_signal("AddGold",value[1])
		#var Note = "[center]You have recived %s gold!" % value[1] 
		#p.emit_signal("NotifyPlayer", Note)
		print(value)
	if(FunctionName.begins_with("OpenShop")):
		var ShopID = FunctionName.split(" ")
		Data.Player.ShowShopUI(null, int(ShopID[1]))

func ConditionCheck(ID):
	var d = Data.Loaded_Dialouge[ID].get("cond")
	var response = Data.Loaded_Dialouge[ID].get("condresp")
	var result
	if(d.has("PlayerYear")):
		if(Data.Player.PlayerYear >= d.get("PlayerYear")):
				print("condition met")
				return true
		else:
			result = response.get("PlayerYear")
			print("condition not met")
			LoadDialouge(null, result)
			return false
		

func UpdateDialogicPlayerDataVariables():
	Dialogic.set_variable("PlayerGender", Data.Player.Gender)
	Dialogic.set_variable("PlayerYear", Data.Player.PlayerYear)
	Dialogic.set_variable("PlayerMoney", Data.Player.gold)
	Dialogic.set_variable("PlayerName", Data.Player.PlayerName)
