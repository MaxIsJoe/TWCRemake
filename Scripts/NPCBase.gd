extends KinematicBody2D

const SPEED = 150
const STATE_WANDERING = 0
const STATE_KILLED = 1

enum Direction{
	UP,
	DOWN,
	LEFT,
	RIGHT
}

onready var Quick_Dia = $Quick_Dia
onready var Dialoug = $Holders/DialougHolder
onready var TimerNode = $Cooldowns/Timer
onready var VisableCharactersTimer = $Quick_Dia/Visable_Chars
onready var acknowledgement_area = $Acknowledgement_area
#onready var WanderCooldown = $Cooldowns/WanderCooldown
#onready var WanderingCooldown = $Cooldowns/WanderingCooldown
#onready var initial_position : Vector2 = global_position

export(String) var NPC_Name = "NPC"
export(String) var Desc = "No description"
export(int) var health = 39000
export(float) var WanderRadius = 140.0
export(bool) var CanWander = false
export(bool) var CanDie = false
export(bool) var HasShop = false
export(bool) var HasQuests = false

var acknowleged_players
var IsGreetingAPlayer = false
var busy = false
var Moving = false
var state = STATE_WANDERING
var result



#######UPDATES########
func _physics_process(delta):
	if(state == STATE_WANDERING):
		#simplewanderAI()
		pass


func _on_Timer_timeout():
	if(!busy):
		Dialoug.QuickDialoug()

func _on_WanderCooldown_timeout():
	if(Moving):
		Moving = false
	if(!Moving):
		Moving = true

#####DIALOUG######
func _on_DialougHolder_send_text(text):
	Quick_Dia.visible_characters = 3000
	Quick_Dia.bbcode_text = "[center]" + text
	VisableCharactersTimer.start()

func _on_Visable_Chars_timeout():
	Quick_Dia.visible_characters = 0


func _on_Acknowledgement_area_body_entered(body):
	if(body.is_in_group("Players")):
		acknowleged_players = body.PlayerName
		Dialoug.QuickGreetings(body.PlayerName)
		


#####WANDERING AI######
# Retuns true if the new position would be behind the target  
func is_beyond(last_pos : Vector2, move : Vector2, target_pos : Vector2) -> bool:
    if(last_pos.x <= target_pos.x && last_pos.x + move.x >= target_pos.x ||
        last_pos.x >= target_pos.x && last_pos.x + move.x <= target_pos.x ||
        last_pos.y <= target_pos.y && last_pos.y + move.y >= target_pos.y ||
        last_pos.y >= target_pos.y && last_pos.y + move.y <= target_pos.y):
            return true
    return false

#func randomize_velocity():
#	velocity = Vector2(randi() % 3 - 1, randi() % 3 - 1)
#	velocity = velocity.normalized() * SPEED / 2

#func simplewanderAI():
#	#If the target position has been reached, pick a new one
#	var hit_pos
#	var move = direction * SPEED
#	var result
#	if(is_beyond(global_position, move, target)):
#		target = initial_position+Vector2(rand_range(-region, region), rand_range(-region, region))
#		#result = target_raycast.intersect_ray(global_position,target)
#		direction = target.normalized() 
#	if(result):
#		hit_pos = result.position