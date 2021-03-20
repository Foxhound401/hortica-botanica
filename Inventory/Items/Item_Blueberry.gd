extends IItem


func _init():
	self.i_id = "Item_Blueberry.gd"
	self.i_name = "Blueberry"
	self.i_image = load("res://Inventory/Items/IconItem_Blueberry.png")
	self.i_description = "A delicious berry that grow in the wilderness."
	self.i_stackable = true
	self.i_maxstack = 5


func i_use(player):
	player.health += 50
	.i_use(player)
