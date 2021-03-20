extends Sprite


var Global
var counter = 0
var random_wait = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	Global = get_tree().get_current_scene().get_node("Global")
	yield(get_tree().create_timer(0.1), "timeout")
	toggle_glow()
		

func toggle_glow():
	if Global.time.is_day_or_night() == "NIGHT":
		show()
	else:
		hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	counter += 1
	if counter > random_wait:
		toggle_glow()
		counter = 0
		random_wait = randi()%50+10
