extends Node2D

var currentDir : int

func LoadAnimatedSprites(sprites: String, target: AnimatedSprite):
	target.frames = load(sprites)
	
func PlayAnim(anim: String, target: AnimatedSprite):
	target.play(anim)
	
func PlayDirectionalAnimAll(Dir: int):
	for anim in get_children():
		if(anim.frames != null):
			match Dir:
				0:
					anim.play("idledown")
					currentDir = 0
				1:
					anim.play("idleleft")
					currentDir = 1
				2:
					anim.play("idleright")
					currentDir = 2
				3:
					anim.play("idleup")
					currentDir = 3
				10:
					anim.play("walkdown")
					currentDir = 10
				11:
					anim.play("walkleft")
					currentDir = 11
				12:
					anim.play("walkright")
					currentDir = 12
				13:
					anim.play("walkup")
					currentDir = 13

func PlayIdleOnAllBasedOnDirection():
	for anim in get_children():
		if(anim.frames != null):
			match currentDir:
				10:
					anim.play("idledown")
					currentDir = 0
				11:
					anim.play("idleleft")
					currentDir = 1
				12:
					anim.play("idleright")
					currentDir = 2
				13:
					anim.play("idleup")
					currentDir = 3
