extends KinematicBody2D

onready var Quick_Dia = $Quick_Dia

export(String) var NPC_Name = "NPC"
export(String) var Desc = "No description"
export(int) var health = 39000
export(bool) var CanMove = false
export(bool) var CanDie = false
export(bool) var HasShop = false
export(bool) var HasQuests = false