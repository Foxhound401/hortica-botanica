extends Node

var player
var physical_player
var ui
var time
var fileio
var weather
var version
var githash
var save_version

func _ready():
	pass

func load_vars():
	player = get_tree().get_current_scene().get_node("Player")
	physical_player = get_tree().get_current_scene().get_node("MapObjects/PlayerPhysicBody")
	ui = get_tree().get_current_scene().get_node("Player/GUI")
	time = $time
	fileio = $fileio
	weather = $weather
	
	var output = []
	OS.execute( 'git', ['rev-parse', '--verify', 'HEAD'], true, output )
	githash = output[0].replace("\n", "")
	version = 0.1
	save_version = 0.1
	
	yield(get_tree().create_timer(0.001), "timeout")
	# Restore the game data
	fileio.restore_game()
	
	# Check if we need to teleport the player (open / close door)
	fileio.check_if_need_to_teleport()

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
