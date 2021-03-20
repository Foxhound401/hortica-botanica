extends IItem


func _init():
	self.i_id = "Item_Mushroom.gd"
	self.i_name = "Mushroom"
	self.i_image = load("res://Inventory/Items/IconItem_Mushroom.png")
	self.i_description = "If you eat me, you will lose 10 health"
	self.i_stackable = true
	self.i_maxstack = 4


func i_use(player):
	player.health -= 10
	.i_use(player)
