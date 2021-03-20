extends Node

func _ready():
	check_if_teleporter_are_unique()
	print("... All tests passed ...")
	

func check_if_teleporter_are_unique():
	var teleporters = get_tree().get_nodes_in_group("Teleporter")
	var names = []
	for node in teleporters:
		names.append(node.name)
	
	for node in teleporters:
		if names.find(node.name) > 1:
			print("TELEPORTER MUST HAVE AN UNIQUE NAME:", node.name, "is not unique")
			get_tree().quit()
