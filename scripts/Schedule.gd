tool
extends Node

"""
--------------------------------------------------------------------------------
Developer Interface to expose variables
--------------------------------------------------------------------------------
"""
# Hours
var time_open = 0
var time_close = 0
# Days of the week
var open_on_lunada = true
var open_on_plutada = true
var open_on_saturnada = true
var open_on_mercuda = true
var open_on_urada = true
var open_on_sunada = true
# Seasons
var open_during_spring = true
var open_during_summer = true
var open_during_harvest = true
var open_during_winter = true

var open_seasons = []
var open_days = []

var _list_of_exported_properties = null

func _set(property, value):
	# Hours
	var category = "time_schedule/"
	if property == category + "time_open":
		time_open = value
	if property == category + "time_close":
		time_close = value
	# Days of the week
	category = "day_schedule/"
	if property == category + "open_on_lunada":
		open_on_lunada = value
	if property == category + "open_on_plutada":
		open_on_plutada = value
	if property == category + "open_on_saturnada":
		open_on_saturnada = value
	if property == category + "open_on_mercuda":
		open_on_mercuda = value
	if property == category + "open_on_urada":
		open_on_urada = value
	if property == category + "open_on_sunada":
		open_on_sunada = value
	# Seasons
	category = "season_schedule/"
	if property == category + "open_during_spring":
		open_during_spring = value
	if property == category + "open_during_summer":
		open_during_summer = value
	if property == category + "open_during_harvest":
		open_during_harvest = value
	if property == category + "open_during_winter":
		open_during_winter = value
	
	property_list_changed_notify()
	return true

func _get(property):
	var category = "time_schedule/"
	if property == category + "time_open":
		return time_open
	if property == category + "time_close":
		return time_close

	category = "day_schedule/"
	if property == category + "open_on_lunada":
		return open_on_lunada
	if property == category + "open_on_plutada":
		return open_on_plutada
	if property == category + "open_on_saturnada":
		return open_on_saturnada
	if property == category + "open_on_mercuda":
		return open_on_mercuda
	if property == category + "open_on_urada":
		return open_on_urada
	if property == category + "open_on_sunada":
		return open_on_sunada

	category = "season_schedule/"
	if property == category + "open_during_spring":
		return open_during_spring
	if property == category + "open_during_summer":
		return open_during_summer
	if property == category + "open_during_harvest":
		return open_during_harvest
	if property == category + "open_during_winter":
		return open_during_winter

func _register_property(name, type):
	_list_of_exported_properties.append(
		{
				"hint": PROPERTY_HINT_NONE,
				"usage": PROPERTY_USAGE_DEFAULT,
				"name": name,
				"type": type
		}
	)

func _get_property_list():
	_list_of_exported_properties = []
	# ------------------------------------------------------------------
	var category = "time_schedule/"
	_register_property(category + "time_open", TYPE_INT)			
	_register_property(category + "time_close", TYPE_INT)
	
	category = "day_schedule/"
	_register_property(category + "open_on_lunada", TYPE_BOOL)
	_register_property(category + "open_on_plutada", TYPE_BOOL)
	_register_property(category + "open_on_saturnada", TYPE_BOOL)
	_register_property(category + "open_on_mercuda", TYPE_BOOL)
	_register_property(category + "open_on_urada", TYPE_BOOL)
	_register_property(category + "open_on_sunada", TYPE_BOOL)
	
	category = "season_schedule/"
	_register_property(category + "open_during_spring", TYPE_BOOL)
	_register_property(category + "open_during_summer", TYPE_BOOL)
	_register_property(category + "open_during_harvest", TYPE_BOOL)
	_register_property(category + "open_during_winter", TYPE_BOOL)

	return _list_of_exported_properties

func is_open():
	if G.time.get_season() in open_seasons:
		print("Open for this season")
		if G.time.get_week_days() in open_days:
			print("Open today")
			if time_open < G.time.get_decimal_hours() and G.time.get_decimal_hours() < time_close:
				 print("Open during this hours")
			else:
				print("**** Closed during this hours")
		else:
			print("Close today")
	else:
		print("**** Closed for this season")
	return false

func _ready():
	if open_during_spring:
		open_seasons.append(0)
	if open_during_summer:
		open_seasons.append(1)
	if open_during_harvest:
		open_seasons.append(2)
	if open_during_winter:
		open_seasons.append(3)

	if open_on_lunada:
		open_days.append(0)
	if open_on_plutada:
		open_days.append(1)
	if open_on_saturnada:
		open_days.append(2)
	if open_on_mercuda:
		open_days.append(3)
	if open_on_urada:
		open_days.append(4)
	if open_on_sunada:
		open_days.append(5)
	
"""
func _process(delta):
	if(is_open()):
		print("it is open")
	else:
		print("it is not open")
"""
