extends AnimatedSprite


var Global
var counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Global = get_tree().get_current_scene().get_node("Global")

func _process(delta):
	counter += 1
	if counter > 10:
		frame = Global.time.get_hours() % 12
		counter = 0
