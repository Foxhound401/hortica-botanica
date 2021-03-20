extends IItem


func _init():
	self.i_id = "Item_Kohlrabi.gd"
	self.i_name = "Kohlrabi"
	self.i_image = load("res://Inventory/Items/IconItem_Kohlrabi.png")
	self.i_description = "Mystical vegetable used in ancient rituals"
	self.i_stackable = true
	self.i_maxstack = 5


func i_use(player):
	player.health += 50
	.i_use(player)
