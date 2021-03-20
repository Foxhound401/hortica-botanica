tool

extends Node2D

signal interacted(sender, item, amount)

export(Script) var directory
export var amount = 1

var is_interactive = true
var item
var instructions = "Press [E] to pick"

# Called when the node enters the scene tree for the first time.
func _ready():
	var player = get_tree().get_nodes_in_group("Player")[0]
	var _succ = connect("interacted", player, "_on_item_interacted")
	item = directory.new()
	instructions = item.i_name
	
	# Set texture
	get_node("Sprite").set_texture(item.i_image)

func action():
	emit_signal("interacted", self, item, amount)
