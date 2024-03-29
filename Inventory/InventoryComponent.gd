class_name Inventory_Component
extends Node


export(String) var inv_name = "Name"
export(int) var inv_slots = 5
export(Array, Script) var start_items
export(Array, int) var start_items_amount
export(PackedScene) var window_scene

var inv_struct_list := Array()
var inv_amount_list := Array()
var interactor = get_parent()
var window_ref # Type: Inventory Window (setting in toggle_window())


func _ready():
	prepare_inventory()
	if start_items.size() == start_items_amount.size() and start_items.size() > 0:
		add_starting_items()


func prepare_inventory():
	inv_struct_list = Array()
	inv_amount_list = Array()
	if inv_struct_list.size() <= 0:
		for _i in range(inv_slots):
			inv_struct_list.append(null)
			inv_amount_list.append(0)


func add_to_inventory(struct:IItem, amount:int):
	var _succ := false
	if struct != null:
		if struct.i_stackable:
			var returned_stack = has_partial_stack(struct)
			if returned_stack[0]:
				_succ = add_to_stack(struct, amount, returned_stack[1])
			else:
				_succ = create_stack(struct, amount)
		else:
			_succ = create_stack(struct, amount)
	return _succ


func has_partial_stack(struct:IItem) -> Array:
	var loc_i: int = -1
	var loc_b: bool = false
	for i in range(inv_amount_list.size()):
		if inv_struct_list[i] != null:
			if inv_struct_list[i].i_name == struct.i_name and inv_amount_list[i] < struct.i_maxstack:
				loc_i = i
				loc_b = true
				break
	return [loc_b, loc_i]


func create_stack(struct:IItem, amount:int) -> bool:
	var has_space := false
	var found_index: int
	for i in range(inv_amount_list.size()):
		if inv_amount_list[i] <= 0:
			has_space = true
			found_index = i
			break
	if has_space:
		if (amount > struct.i_maxstack):
			inv_amount_list[found_index] = struct.i_maxstack
			add_to_inventory(struct, amount - struct.i_maxstack)
		elif amount > 1 and not struct.i_stackable:
			inv_amount_list[found_index] = 1
			add_to_inventory(struct, amount - 1)
		else:
			inv_amount_list[found_index] = amount
		inv_struct_list[found_index] = struct
		refresh_slot_at_index(found_index)
		return true
	else:
		return false


func add_to_stack(struct:IItem, amount:int, index:int):
	var current_amount = inv_amount_list[index]
	print("amount: ", current_amount)
	if (current_amount + amount) > inv_struct_list[index].i_maxstack:
		inv_amount_list[index] = struct.i_maxstack
		var _calc = amount - (struct.i_maxstack - current_amount)
		if add_to_inventory(struct, _calc):
			refresh_slot_at_index(index)
	else:
		inv_amount_list[index] += amount
		struct.queue_free()
		refresh_slot_at_index(index)
	return true


func add_starting_items():
	for i in start_items.size():
		var item = start_items[i].new()
		
		if item.i_stackable and start_items_amount[i] > item.i_maxstack:
			add_to_inventory(item, item.i_maxstack)
		else:
			add_to_inventory(item, start_items_amount[i])


func inv_query(item_name: String, item_amount: int) -> bool:
	var total: int = 0
	for i in range(inv_struct_list.size()):
		if inv_struct_list[i] != null:
			if inv_struct_list[i].i_name == item_name:
				total += inv_amount_list[i]
	return total >= item_amount


func use_item_at_slot(index: int):
	if inv_amount_list[index] > 0:
		inv_struct_list[index].i_use(interactor)
		if inv_struct_list[index].i_consumable:
			inv_amount_list[index] -= 1
			refresh_slot_at_index(index)


func refresh_slot_at_index(index: int):
	if window_ref != null:
		window_ref.slot_list[index].refresh_slot()

func select_slot_at_index(index: int):
	if window_ref != null:
		window_ref.slot_list[index].select_slot()
		if inv_amount_list[index] > 0:
			return inv_struct_list[index]
		else:
			return null

func unselect_all_slots():
	if window_ref != null:
		var idx = 0
		while idx < inv_slots:
			window_ref.slot_list[idx].unselect_slot()
			idx += 1

func toggle_window():
	if window_ref == null:
		show_window()
	else:
		hide_window()

func show_window():
	interactor = G.player
	var new_window = window_scene.instance()
	new_window.inv_comp = self
	interactor.gui.add_child(new_window)
	window_ref = new_window

func hide_window():
	window_ref.queue_free()
	interactor = get_parent()

func save():
	var arr = []
	var idx = 0
	while idx < inv_slots:
		if inv_struct_list[idx] != null:
			var save_inv = {
			"item_id":inv_struct_list[idx].i_id,
			"amount":inv_amount_list[idx]
			}
			arr.append(save_inv)
		idx += 1
	
	var save_dict = {
		"name": name,
		"inventory": arr
	}
	return save_dict

func restore(data):
	
	# When restoring we hide the window if its displayed
	var was_hidden = true
	if window_ref != null:
		was_hidden = false
		hide_window()
	prepare_inventory()
	for item in data["inventory"]:
		var path = load("res://Inventory/Items/" + item["item_id"])
		add_to_inventory(path.new(), item["amount"])
	
	if not was_hidden:
		show_window()
