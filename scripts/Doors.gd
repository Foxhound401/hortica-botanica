extends Node2D

export var location_name = "REPLACE WITH INSTRUCTIONS"
export var level_to_load = "" 
export var is_interactive = true

export var restrict_opening = false
export var time_open = 0
export var time_close = 0

export var other_door = ""

var Global = null
var instructions

func _ready():
	Global = get_tree().get_current_scene().get_node("Global")
	$position_to_teleport.hide()

func define_instructions():
	# By default instructions are the location name
	var output = location_name
	
	# If the door is interactive it is open else it is forced to be locked and we ignore the schedule
	if is_interactive:
		output = location_name + " (open)"
	else:
		return location_name + " (locked)"

	# We check if we must apply a schedule if it is closed we display when the opening hours are
	if restrict_opening:
		if is_open():
			output = location_name + " (now open)"
		else:
			output = location_name + " (closed) " + "open from " + str(time_open) + " to " + str(time_close)
	return output

func is_open():
	if time_open < Global.time.get_decimal_hours() and Global.time.get_decimal_hours() < time_close:
		return true
	return false

func _process(delta):
	instructions = define_instructions()

func action():
	Global.save_game()
	# By default we save the player data
	var door_position = File.new()
	door_position.open("user://door_position.save", File.WRITE)
	
	var node_data = {
		"other_door": other_door,
		"active": true
	}
	door_position.store_line(to_json(node_data))
	door_position.close()
	
	get_tree().change_scene(level_to_load)
