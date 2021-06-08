extends CanvasLayer

var last_modifier = null
var refresh_time

func _ready():
	refresh_time = 0
	$TextInstructions.hide()

func _process(delta):
	refresh_time += delta
	if refresh_time > 0.5:
		$HoursLabel.text = G.time.get_hours_as_string()
		$DayLabel.text = G.time.get_day_as_string()
		$SeasonLabel.text = G.time.get_season_as_string()
		$WeatherLabel.text = G.weather.get_current_weather_as_string()
		$StaminaLabel/ProgressBar.value = G.physical_player.stamina
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
	G.fileio.save_game()


func _on_Button2_pressed():
	G.fileio.restore_game()


func _on_TimeFast_pressed():
	G.time.speed = 8.0

func _on_TimeNormal_pressed():
	G.time.speed = 2.0


func _on_TimeFaster_pressed():
	G.time.speed = 32.0


func _on_TimeAddDay_pressed():
	G.time.time_epoch += 720


func _on_TimeAddDays_pressed():
	G.time.time_epoch += 7200
