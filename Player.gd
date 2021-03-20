extends Node


export(NodePath) var gui_path = "GUI"
var health := 100
onready var gui = get_node(gui_path)

var Global
var select_slot = 0
var current_item = null

func _ready():
	Global = get_tree().get_current_scene().get_node("Global")
	$InventoryComponentQuickMenu.toggle_window()
	$InventoryComponentQuickMenu.select_slot_at_index(0)
	print("Ready player one")

func _input(event):
	if event.is_action_pressed("ui_inventory"):
		$InventoryComponent.toggle_window()
	
	# Query test by hitting 'Esc' for Apple
	if event.is_action_pressed("ui_cancel"):
		if $InventoryComponent.inv_query("Apple", 2):
			print("it has 2 apples or more")
		else:
			print("doesn't have 2 apples")
	
	if event.is_action_pressed("ui_wheel_up"):
		select_slot -= 1
		if select_slot < 0:
			select_slot = 5
		update_selected_slot()
	
	if event.is_action_pressed("ui_wheel_down"):
		select_slot += 1
		if select_slot > 5:
			select_slot = 0
		update_selected_slot()
	

func update_selected_slot():
	$InventoryComponentQuickMenu.unselect_all_slots()
	current_item = $InventoryComponentQuickMenu.select_slot_at_index(select_slot)
	Global.physical_player.set_current_item_icon(current_item)

func _on_item_interacted(sender, item, amount):
	if $InventoryComponentQuickMenu.add_to_inventory(item, amount):
		sender.queue_free()
		current_item = $InventoryComponentQuickMenu.select_slot_at_index(select_slot)
		Global.physical_player.set_current_item_icon(current_item)

func save():
	var save_dict = {
		"name" : name,
	}
	return save_dict

func restore(_data):
	pass
