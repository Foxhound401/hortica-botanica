tool

extends Node2D

var location_name = "Null"
var restricted_opening = false
var is_interactive = true
var level_to_load = "" 
var message_when_not_interactive = "Null"
var position_to_teleport = ""
var time_open = 0
var time_close = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _set(property, value):
	if property == "location_name":
		location_name = value
	if property == "restricted_opening":
		restricted_opening = value # One can implement custom setter logic here
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

func _get_property_list():
	var base_property = [
			{
				"hint": PROPERTY_HINT_NONE,
				"usage": PROPERTY_USAGE_DEFAULT,
				"name": "location_name",
				"type": TYPE_STRING
			}]
	
	base_property.append(
			{
				"hint": PROPERTY_HINT_NONE,
				"usage": PROPERTY_USAGE_DEFAULT,
				"name": "is_interactive",
				"type": TYPE_BOOL
			})
	
	if not is_interactive:
		base_property.append(
			{
				"hint": PROPERTY_HINT_NONE,
				"usage": PROPERTY_USAGE_DEFAULT,
				"name": "message_when_not_interactive",
				"type": TYPE_STRING
			})
	else:
		base_property.append(
			{
				"hint": PROPERTY_HINT_NONE,
				"usage": PROPERTY_USAGE_DEFAULT,
				"name": "level_to_load",
				"type": TYPE_STRING
			})
		base_property.append(
			{
				"hint": PROPERTY_HINT_NONE,
				"usage": PROPERTY_USAGE_DEFAULT,
				"name": "position_to_teleport",
				"type": TYPE_STRING
			})
		base_property.append(
			{
				"hint": PROPERTY_HINT_NONE,
				"usage": PROPERTY_USAGE_DEFAULT,
				"name": "restricted_opening",
				"type": TYPE_BOOL
			})
		if restricted_opening:
			base_property.append({
					"hint": PROPERTY_HINT_NONE,
					"usage": PROPERTY_USAGE_DEFAULT,
					"name": "restricted_opening/time_open",
					"type": TYPE_INT
				})
			base_property.append({
					"hint": PROPERTY_HINT_NONE,
					"usage": PROPERTY_USAGE_DEFAULT,
					"name": "restricted_opening/time_close",
					"type": TYPE_INT
				})
	return base_property
