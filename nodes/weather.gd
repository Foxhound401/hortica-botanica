extends Node

enum weather {CLEAR, SNOW, RAIN, STORM}

var current_weather

# Called when the node enters the scene tree for the first time.
func _ready():
	current_weather = weather.CLEAR

func _process(delta):
	pick_next_weather()

func pick_next_weather():
	randomize()
	var weather_probability = randi()%100+1
	
	# By default the weather is clear
	var new_weather = weather.CLEAR

	if G.time.get_season() == G.time.seasons.SPRING:
		# Spring has ~40% chances of rain
		if weather_probability < 40:
			new_weather = weather.RAIN
		
		# It is very very rare but sometimes it can snow during the first 3 days of spring
		#if 
	
	#if G.time.get_season() == G.time.seasons.SPRING:
