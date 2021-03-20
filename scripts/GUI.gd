extends CanvasLayer

var last_modifier = null
var Global
var refresh_time

func _ready():
	refresh_time = 0
	Global = get_tree().get_current_scene().get_node("Global")
	$TextInstructions.hide()

func _process(delta):
	refresh_time += delta
	if refresh_time > 0.5:
		$HoursLabel.text = Global.time.get_hours_as_string()
		$DayLabel.text = Global.time.get_day_as_string()
		$SeasonLabel.text = Global.time.get_season_as_string()
		refresh_time = 0

func reset_instructions(modifier):
	# We only allow to reset by the original sender
	if modifier.i_hash_id == last_modifier:
		get_node("TextInstructions").hide()
		get_node("TextInstructions").text = ""

func set_instructions(text, modifier):
	get_node("TextInstructions").show()
	get_node("TextInstructions").text = text
	last_modifier = modifier.i_hash_id

func _on_Button_pressed():
	Global.save_game()


func _on_Button2_pressed():
	Global.restore_game()


func _on_TimeFast_pressed():
	Global.time.speed = 8.0

func _on_TimeNormal_pressed():
	Global.time.speed = 2.0


func _on_TimeFaster_pressed():
	Global.time.speed = 32.0
