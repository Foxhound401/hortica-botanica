extends Node

var dspeed
var time_epoch
var speed
var counter = 0

enum seasons {SPRING, SUMMER, HARVEST, WINTER}
var season_names = ["Spring", "Summer", "Harvest", "Winter"]

var days_name = ["Lunada", "Plutada", "Saturnada", "Mercuda", "Urada", "Sunada"] 

func _ready():
	time_epoch = 0
	speed = 2.0

func get_minutes():
	return int(time_epoch) % 60

func get_hours():
	return int(time_epoch / 60.0) % 24

func get_decimal_hours():
	return get_hours() + (get_minutes() * 0.016)

func get_days():
	return int(time_epoch / 1440.0)

func get_week_days():
	return int(time_epoch / 1440.0) % 6

func get_season():
	var season =  (int(time_epoch / 1440.0) / 30) % 4
	if season == 0:
		return seasons.SPRING
	if season == 1:
		return seasons.SUMMER
	if season == 2:
		return seasons.HARVEST
	if season == 3:
		return seasons.WINTER

func is_day_or_night():
	if get_decimal_hours() > 6.0 and get_decimal_hours() < 20.0:
		return "DAY"
	else:
		return "NIGHT"

func t_str(value):
	if value < 10:
		return "0" + str(value)
	else:
		return str(value)

func get_day_as_string():
	var output = "Days: "
	output += t_str(get_days())
	return  output

func get_hours_as_string():
	var output = ""
	output += t_str(get_hours()) + ":" + t_str(get_minutes())
	return output

func get_season_as_string():
	return season_names[get_season()]

func save():
	var save_dict = {
		"name" : name,
		"time_epoch": int(time_epoch)
	}
	return save_dict

func restore(data):
	print(get_season())
	time_epoch = data["time_epoch"]

func _process(delta):
	dspeed = delta * speed
	counter += dspeed
	if counter >= 1:
		counter = 0
		time_epoch += 1

