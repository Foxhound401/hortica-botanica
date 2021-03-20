extends Node

# This is used to link variable global accross the whole project

var player
var physical_player
var ui
var time
var save_file_path
var version
var save_version
var githash

func _ready():
	
	# By default we restore player's data
	yield(get_tree().create_timer(0.001), "timeout")
	#restore_game()
	



func save_game():
	pass


func restore(_data):
	pass


