extends Node2D

# Used to manage day/night cycle for glowing things in the game (lantens, windows, etc).
enum MODE {always_on, always_off, automatic}
export (MODE) var mode = MODE.automatic

var counter = 0
var random_wait = 0

func _ready():
	randomize()
	yield(get_tree().create_timer(0.2), "timeout")
	toggle_glow()
	$AnimationPlayer.playback_speed = randf()*0.5
		

func toggle_glow():
	if mode == MODE.automatic:
		if G.time.is_day_or_night() == "NIGHT":
			$Glow.show()
		else:
			$Glow.hide()
	if mode == MODE.always_on:
		$Glow.show()
	if mode == MODE.always_off:
		$Glow.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	counter += G.time.dspeed
	if counter > random_wait:
		toggle_glow()
		counter = 0
		random_wait = randi()%20+10
