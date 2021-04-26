extends Node

enum weather {CLEAR, SNOW, RAIN, STORM, FOG}

var current_weather
var counter = 0
var random_wait = 120

# Called when the node enters the scene tree for the first time.
func _ready():
	current_weather = weather.CLEAR
	#change_weather()

func _process(delta):
	counter += G.time.dspeed
	if counter > random_wait:
		pick_next_weather()
		counter = 0
		random_wait = randi()%240+240

func change_weather():
	G.physical_player.set_weather(current_weather)

func get_current_weather_as_string():
	return get_weather_as_string(current_weather)

func get_weather_as_string(w):
	if w == weather.CLEAR:
		return "Clear sky"
	if w == weather.SNOW:
		return "Snowing"
	if w == weather.RAIN:
		return "Raining"
	if w == weather.STORM:
		return "Storm"
	if w == weather.FOG:
		return "Foggy"
	return "ERROR unknown weather"

func pick_next_weather():
	randomize()
	var weather_probability = randi()%100+1
	
	# By default the weather is clear
	var new_weather = weather.CLEAR

	if G.time.get_season() == G.time.seasons.SPRING:
		if weather_probability < 40:
			new_weather = weather.RAIN
		# Very low probability of snow in early spring during night
		if G.time.get_day_of_season() < 3 and weather_probability < 5 and  G.time.is_day_or_night() == "NIGHT":
			new_weather = weather.SNOW
	
	if G.time.get_season() == G.time.seasons.SUMMER:
		if G.time.is_day_or_night() == "NIGHT":
			if weather_probability < 30:
				new_weather = weather.RAIN
			if weather_probability < 10:
				new_weather = weather.STORM

	if G.time.get_season() == G.time.seasons.HARVEST:
		if weather_probability < 60:
			new_weather = weather.FOG
		if weather_probability < 30:
			new_weather = weather.RAIN

	if G.time.get_season() == G.time.seasons.WINTER:
		if weather_probability < 40:
			new_weather = weather.SNOW
		if weather_probability < 15:
			new_weather = weather.FOG
	
	if new_weather != current_weather:
		current_weather = new_weather
		change_weather()
