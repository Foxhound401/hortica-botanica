# Provide save / restore functions for the game

extends Node

onready var save_file_path = "user://savegame.save"
onready var door_file_path = "user://door_position.save"

# Function to sanitize the node path and remove any specificity to the level
func get_sanitized_path(node):
	var sanitized_path = str(node.get_path()).replace("/", "")
	sanitized_path = sanitized_path.replace(get_tree().get_current_scene().name, "SCENE")
	return sanitized_path

func teleport_to(data):
	var teleporters = get_tree().get_nodes_in_group("Teleporter")
	for node in teleporters:
		if node.name == data.other_door:
			print("teleport to", node.get_node("position_to_teleport").global_position)
			G.physical_player.position = node.get_node("position_to_teleport").global_position

func check_if_need_to_teleport():
	# Restore when moving from one place to the other
	var json_data
	var file = File.new()
	if file.file_exists(door_file_path):
		file.open(door_file_path, File.READ)
		json_data = file.get_as_text().split("\n")
		file.close()
		
		var data = parse_json(json_data[0])
		print(data)
		# move the player to the door place
		if data.active:
			teleport_to(data)
		
		data.active = false
		file.open(door_file_path, File.WRITE)
		file.store_line(to_json(data))
		file.close()

func save_game():
	print("... Save player data ...")
	
	var player_data_file = File.new()
	player_data_file.open(save_file_path, File.WRITE)
	
	var player_data_nodes = get_tree().get_nodes_in_group("Persist")
	for node in player_data_nodes:
		
		# Call the node's save function.
		var node_data = node.call("save")
		node_data["path"] = get_sanitized_path(node)
		# Store the save dictionary as a new line in the save file.
		player_data_file.store_line(to_json(node_data))
	
	player_data_file.close()
	
	var world_name = get_tree().get_current_scene().name
	print("... Save world data for ", world_name, " ...")
	var world_data_file = File.new()
	world_data_file.open("user://data" + world_name + ".save", File.WRITE)
	
	var world_data_nodes = get_tree().get_nodes_in_group("PersistWorld")
	for node in world_data_nodes:

		# Call the node's save function.
		var node_data = node.call("save")
		node_data["path"] = get_sanitized_path(node)

		# Store the save dictionary as a new line in the save file.
		world_data_file.store_line(to_json(node_data))
	world_data_file.close()
	
	print("... Game saved ...")

func restore_game():
	print("... Restore player data ...")
	restore_save_file(save_file_path, "Persist")
	
	var world_name = get_tree().get_current_scene().name
	restore_save_file("user://data" + world_name + ".save", "PersistWorld")

func restore_save_file(file_path, group_to_restore):
	var json_data = []
	
	var file = File.new()
	if file.file_exists(file_path):
		file.open(file_path, File.READ)
		json_data = file.get_as_text().split("\n")
		file.close()
	
		var data = {}
		for i in json_data:
			if len(i) > 1:
				data[parse_json(i)["path"]] = parse_json(i)

		var restore_nodes = get_tree().get_nodes_in_group(group_to_restore)
		for node in restore_nodes:
			var node_path = get_sanitized_path(node)
			print("Restore: ", node_path)
			if data.has(node_path):
				node.restore(data[node_path])
	else:
		print("File save not found ...")
