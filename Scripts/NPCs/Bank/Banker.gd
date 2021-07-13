extends MobEnity_NPC


func _ready():
	#This is the only way I managed to get this working unfortuntly
	#Grouping them all in one sprite then randomly picking frames doesn't work
	var spriteToChoose = int(rand_range(1,3))
	match spriteToChoose:
		1:
			SpriteHandler.PlayAnim("1", $SpriteHandler/Body)
		2:
			SpriteHandler.PlayAnim("2", $SpriteHandler/Body)
		3:
			SpriteHandler.PlayAnim("3", $SpriteHandler/Body)
			
