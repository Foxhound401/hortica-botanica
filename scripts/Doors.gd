tool
extends Node2D

"""
--------------------------------------------------------------------------------
Developer Interface to expose variables
--------------------------------------------------------------------------------
"""

var location_name = "Null"
var restricted_opening = false
var is_interactive = true
var level_to_load = "" 
var message_when_not_interactive = "Null"
var position_to_teleport = ""
var time_open = 0
var time_close = 0
var instructions = "REPLACE WITH INSTRUCTIONS"

var _list_of_exported_properties = null

func _set(property, value):
	if property == "location_name":
		location_name = value
	if property == "restricted_opening":
		restricted_opening = value
	if property == "is_interactive":
		is_interactive = value
	if property == "level_to_load":
		level_to_load = value
	if property == "position_to_teleport":
		position_to_teleport = value
	if property == "message_when_not_interactive":
		message_when_not_interactive = value
	if property == "restricted_opening/time_open":
		time_open = value
	if property == "restricted_opening/time_close":
		time_close = value
	property_list_changed_notify()
	return true

func _get(property):
	if property == "location_name":
		return location_name
	if property == "restricted_opening":
		return restricted_opening
	if property == "is_interactive":
		return is_interactive
	if property == "level_to_load":
		return level_to_load
	if property == "position_to_teleport":
		return position_to_teleport
	if property == "message_when_not_interactive":
		return message_when_not_interactive
	if property == "restricted_opening/time_open":
		return time_open
	if property == "restricted_opening/time_close":
		return time_close

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
	# Location name, show to the player where the door will open
	# --------------------------------------------------------------------------
	_register_property("location_name", TYPE_STRING)
	
	# If the door is interactive (can be open)
	# --------------------------------------------------------------------------
	_register_property("is_interactive", TYPE_BOOL)
	
	if not is_interactive:
		# What to show to the player when the door is not interactive
		# ----------------------------------------------------------------------
		_register_property("message_when_not_interactive", TYPE_STRING)

	else:
		# Which level to load when opening the door
		# ----------------------------------------------------------------------
		_register_property("level_to_load", TYPE_STRING)

		# The name of the door on the other side to know the position to teleport the player
		# ----------------------------------------------------------------------
		_register_property("position_to_teleport", TYPE_STRING)

		# If the door is only open during a schedule
		# ----------------------------------------------------------------------
		_register_property("restricted_opening", TYPE_BOOL)
		
		if restricted_opening:
			# Specify the schedule of opening / closing
			# ------------------------------------------------------------------
			_register_property("restricted_opening/time_open", TYPE_INT)			
			_register_property("restricted_opening/time_close", TYPE_INT)

	return _list_of_exported_properties

"""
--------------------------------------------------------------------------------
Logic code
--------------------------------------------------------------------------------
"""

func _ready():
	if not Engine.editor_hint:
		$position_to_teleport.hide()

func _process(_delta):
	if not Engine.editor_hint:
		instructions = define_instructions()

func action():
	G.fileio.save_game()
	# By default we save the player data
	var door_position = File.new()
	door_position.open("user://door_position.save", File.WRITE)
	
	var node_data = {
		"other_door": position_to_teleport,
		"active": true
	}
	door_position.store_line(to_json(node_data))
	door_position.close()
	
	get_tree().change_scene("res://levels/" + level_to_load)

func define_instructions():
	# By default instructions are the location name
	var output = location_name
	
	# If the door is interactive it is open else it is forced to be locked and we ignore the schedule
	if is_interactive:
		output = location_name + " (open)"
	else:
		return location_name + " (locked)"

	# We check if we must apply a schedule if it is closed we display when the opening hours are
	if restricted_opening:
		if is_open():
			output = location_name + " (now open)"
		else:
			output = location_name + " (closed) " + "open from " + G.time.t_str(time_open) + ":00 to " + G.time.t_str(time_close) + ":00"
	return output

func is_open():
	if time_open < G.time.get_decimal_hours() and G.time.get_decimal_hours() < time_close:
		return true
	return false

