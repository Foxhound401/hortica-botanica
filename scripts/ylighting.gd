extends Node2D

var shapes


# Called when the node enters the scene tree for the first time.
func _ready():
	#shapes = [$Logo]
	shapes = get_tree().get_nodes_in_group("ylight")
	
	for shape in shapes:
		var night_shape = shape.duplicate()
		shape.add_child(night_shape)
		night_shape.set_name("night_" + night_shape.get_name())
		night_shape.set_light_mask(0)
		night_shape.set_position(Vector2(0, 0))
		if shape.get_node_or_null("ypos") != null:
			shape.get_node("ypos").hide()
			night_shape.get_node("ypos").hide()


func _process(delta):
	
	for shape in shapes:
		var shape_y_position = 0
		if shape.get_node_or_null("ypos") == null:
			shape_y_position = shape.get_global_position().y
		else:
			shape_y_position = shape.get_node("ypos").get_global_position().y
		
		shape_y_position -= 10

		var player_delta = G.physical_player.get_global_position().y - shape_y_position
		var night_shape = shape.get_node("night_" + shape.get_name())
		
		var opacity_factor = (clamp(player_delta, -10, 10) + 10) / 0.2
		opacity_factor = (100.0 - opacity_factor) / 100
		#print(opacity_factor)
		
		night_shape.modulate.a = opacity_factor
		
		"""
		if player_delta < 0:
			night_shape.show()
		else:
			night_shape.hide()
		"""
