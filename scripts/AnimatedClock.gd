extends AnimatedSprite

var counter = 0

func _ready():
	pass

func _process(delta):
	counter += 1
	if counter > 10:
		frame = G.time.get_hours() % 12
		counter = 0
