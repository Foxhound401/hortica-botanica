extends Node

# This is used to link variable global accross the whole project
# Reddit password: 

var player
var physical_player
var ui
var time
var save_file_path
var version
var save_version
var githash

# Called when the node enters the scene tree for the first time.
func _ready():
	
	check_if_teleporter_are_unique()
	
	var output = []
	OS.execute( 'git', ['rev-parse', '--verify', 'HEAD'], true, output )
	githash = output[0].replace("\n", "")
	version = 0.1
	save_version = 0.1
	player = get_tree().get_current_scene().get_node("Player")
	ui = get_tree().get_current_scene().get_node("Player/GUI")
	time = get_tree().get_current_scene().get_node("Global/TimeKeeper")
	physical_player = get_tree().get_current_scene().get_node("MapObjects/PlayerPhysicBody")
	#$CanvasModulate.show()
	
	save_file_path = "user://savegame.save"
	
	# By default we restore player's data
	yield(get_tree().create_timer(0.001), "timeout")
	restore_game()
	
	# Restore when moving from one place to the other
	var json_data
	var file = File.new()
	file.open("user://door_position.save", File.READ)
	json_data = file.get_as_text().split("\n")
	file.close()
	
	var data = parse_json(json_data[0])
	print(data)
	# move the player to the door place
	if data.active:
		teleport_to(data)
	
	data.active = false
	file.open("user://door_position.save", File.WRITE)
	file.store_line(to_json(data))
	file.close()

func teleport_to(data):
	var teleporters = get_tree().get_nodes_in_group("Teleporter")
	for node in teleporters:
		if node.name == data.other_door:
			print("teleport to", node.get_node("position_to_teleport").global_position)
			physical_player.position = node.get_node("position_to_teleport").global_position

func check_if_teleporter_are_unique():
	var teleporters = get_tree().get_nodes_in_group("Teleporter")
	var names = []
	for node in teleporters:
		names.append(node.name)
	
	for node in teleporters:
		if names.find(node.name) > 1:
			print("TELEPORTER MUST HAVE AN UNIQUE NAME:", node.name, "is not unique")
			get_tree().quit()

func restore_game():
	print("... Restore game data ...")
	var json_data = []
	
	var file = File.new()
	if file.file_exists(save_file_path):
		file.open(save_file_path, File.READ)
		json_data = file.get_as_text().split("\n")
		file.close()
	
	var data = {}
	for i in json_data:
		if len(i) > 1:
			data[parse_json(i)["path"]] = parse_json(i)

	var restore_nodes = get_tree().get_nodes_in_group("Persist")
	for node in restore_nodes:
		var node_path = get_sanitized_path(node)
		print("Restore: ", node_path)
		node.restore(data[node_path])

func save_game():
	print("... Save game data ...")
	
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		print("Save: ", node.get_path())
		
		# Check if node is an instanced scene
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check if node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		
		# Call the node's save function.
		var node_data = node.call("save")
		node_data["path"] = get_sanitized_path(node)

		# Store the save dictionary as a new line in the save file.
		save_game.store_line(to_json(node_data))
	
	save_game.close()
	print("... Game saved ...")

# Function to sanitize the node path and remove any specificity to the level
func get_sanitized_path(node):
	var sanitized_path = str(node.get_path()).replace("/", "")
	sanitized_path = sanitized_path.replace(get_tree().get_current_scene().name, "SCENE")
	return sanitized_path

func restore(_data):
	pass

func save():
	var save_dict = {
		"name" : name,
		"version": version,
		"githash": githash,
		"save_version": save_version
	}
	return save_dict
