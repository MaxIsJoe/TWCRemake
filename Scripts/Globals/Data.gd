extends Node

####Data####
##Here all data that needs to be stored and referenced will be put here.##

var main_node
var ForbiddenNames = ["robed figure",
				"masked figure",
				"deatheater",
				"auror",
				"harry",
				"potter",
				"albus",
				"malfoy",
				"snape",
				"hermoine",
				"voldemort",
				"dumbledore",
				"riddle",
				"potter",
				"granger",
				"malfoy",
				"weasley",
				"lestrange",
				"sirius",
				"riddle",
				"lestrange",
				"black",
				"marvello",
				"ben copper",
				"penny haywood",
				"muller sydney",
				"muller"] #These are the forbidden names that the player cannot use, it's the same list from the original game.

#Always present#
#Inventory and Items#
var ItemJSON = "res://Resources/Items/Items.JSON"
var ItemData

#Spells
var SpellsJSON = "res://Resources/Spells/SpellData.JSON"
var SpellsData
var Inflamri = load("res://Scenes/Instances/Actors/Spells/Projectiles/Inflamri.tscn")
var Episkey = load("res://Scenes/Instances/Actors/Spells/Target/Episkey.tscn")

#Scenes
var PlayerBase = preload("res://Scenes/Instances/Actors/player/Player.tscn")

##Images##
var UI_Icon_Shop = "res://Sprites/UI/BagOSnow_Converted.png"
var UI_Icon_Dia = "res://Sprites/UI/Dia_Icon.png"
var UI_Icon_Grab = "res://Sprites/UI/grab.png"

##Groups##
var Group_DiaNode
var Group_ShopHolders

##Animated Textures##
var Base_Female : String = "res://Resources/AnimatedTextures/PlayerBases/Female/FemaleStaff.tres"
var Base_Male   : String = "res://Resources/AnimatedTextures/PlayerBases/Male/MaleStaff.tres"
var Grif_Female : String = "res://Resources/AnimatedTextures/PlayerBases/Female/FemaleGrif.tres"
var Grif_Male   : String = "res://Resources/AnimatedTextures/PlayerBases/Male/GrifMale.tres"
var Slyth_Female: String = "res://Resources/AnimatedTextures/PlayerBases/Female/FemaleSlyth.tres"
var Slyth_Male  : String = "res://Resources/AnimatedTextures/PlayerBases/Male/SlythMale.tres"
var Huff_Female : String = "res://Resources/AnimatedTextures/PlayerBases/Female/FemaleHuff.tres"
var Huff_Male   : String = "res://Resources/AnimatedTextures/PlayerBases/Male/MaleHuff.tres"
var Claw_Female : String = "res://Resources/AnimatedTextures/PlayerBases/Female/FemaleClaw.tres"
var Claw_Male   : String = "res://Resources/AnimatedTextures/PlayerBases/Male/MaleClaw.tres"

#Temp#
#Dialouge#
var Loaded_Dialouge
var Player

func UpdateDiaNodeVar():
	Group_DiaNode = get_tree().get_nodes_in_group("DiaUI")

func Update_Group_ShopHolders():
	Group_ShopHolders = get_tree().get_nodes_in_group("shop")
