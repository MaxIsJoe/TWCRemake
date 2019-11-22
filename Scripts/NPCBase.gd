extends KinematicBody2D

const SPEED = 150

export(String) var NPC_Name = "NPC"
export(String) var Desc = "No description"
export(int) var health = 39000
export(float) var WanderRadius = 140.0
export(bool) var CanWander = false
export(bool) var CanDie = false
export(bool) var HasShop = false
export(bool) var HasQuests = false

onready var Quick_Dia = $Quick_Dia
onready var Dialoug = $Holders/DialougHolder
onready var TimerNode = $Cooldowns/Timer
onready var VisableCharactersTimer = $Quick_Dia/Visable_Chars
onready var acknowledgement_area = $Acknowledgement_area
#onready var WanderCooldown = $Cooldowns/WanderCooldown
#onready var WanderingCooldown = $Cooldowns/WanderingCooldown
#onready var initial_position : Vector2 = global_position


var acknowleged_players
var IsGreetingAPlayer = false
var busy = false
var Moving = false
#var state = STATE_WANDERING
var result