class_name IInteractiveNode
extends Area2D

var i_hash_id = null
var i_is_inside = false
var i_delayed_activation = false

func init(root):
	randomize()
	i_hash_id = randi() % 999999999

	connect("body_exited", self, "_on_character_exit")
	connect("body_entered", self, "_on_character_enter")

	yield(get_tree().create_timer(0.1), "timeout")
	i_delayed_activation = true

	var test = root.instructions
	test = root.is_interactive
