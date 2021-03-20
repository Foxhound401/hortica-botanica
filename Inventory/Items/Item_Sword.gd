extends IItem


func _init():
	self.i_id = "Item_Sword.gd"
	self.i_name = "Sword"
	self.i_image = load("res://Inventory/Items/IconItem_Sword.png")
	self.i_description = "You can use it to defeat bad guys"
	self.i_stackable = false


func i_use(player):
	player.health -= 10
	.i_use(player)
