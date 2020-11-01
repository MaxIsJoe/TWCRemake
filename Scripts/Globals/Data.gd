extends Node

####Data####
##Here all data that needs to be stored and referenced will be put here.##

#Always present#
#Inventory and Items#
var ItemJSON = "res://Resources/Items/Items.JSON"
var ItemData

#Spells
var SpellsJSON = "res://Resources/Spells/SpellData.JSON"
var SpellsData

##Images##
var UI_Icon_Shop = "res://Sprites/UI/BagOSnow_Converted.png"
var UI_Icon_Dia = "res://Sprites/UI/Dia_Icon.png"
var UI_Icon_Grab = "res://Sprites/UI/grab.png"

##Groups##
var Group_DiaNode
var Group_ShopHolders

#Temp#
#Dialouge#
var Loaded_Dialouge
var Player

func UpdateDiaNodeVar():
	Group_DiaNode = get_tree().get_nodes_in_group("DiaUI")

func Update_Group_ShopHolders():
	Group_ShopHolders = get_tree().get_nodes_in_group("shop")
