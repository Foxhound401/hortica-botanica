extends IItem


func _init():
	self.i_id = "Item_Bucket.gd"
	self.i_name = "Bucket"
	self.i_image = load("res://Inventory/Items/IconItem_Bucket.png")
	self.i_description = "Buckets are tools which are used to carry liquids like water"
	self.i_stackable = false


func i_use(player):
	player.health += 10
	.i_use(player)
