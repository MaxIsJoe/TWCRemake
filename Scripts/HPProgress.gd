extends TextureProgressBar

@export var HealthOverlayPath: NodePath
@export var HealthPath: NodePath

var Health
var HealthOverlay
var material_onOverlay

func _ready():
	HealthOverlay = get_node(HealthOverlayPath)
	Health = get_node(HealthPath)
	material_onOverlay = HealthOverlay.get_material()

func _on_Player_hpupdate(health, max_health):
	max_value = max_health
	$Tween.interpolate_property(self, "value",
		value, health, 1,
		Tween.EASE_OUT , Tween.EASE_IN_OUT)
	$Tween.start()
	GrayScaleVision()


##Notes about grayscale##
#Tweening this causes the screen to flicker too much when receiving too much damage
#avoid tweening this for now until we find a way to not cause epilepsy
func GrayScaleVision():
	if(Health != null):
		if(Health.CanGrayscaleVision == true):
			var grayscale_value : float = float((Health.HP_MAX - Health.HP)) / 100
			material_onOverlay.set_shader_parameter("scale",grayscale_value)
