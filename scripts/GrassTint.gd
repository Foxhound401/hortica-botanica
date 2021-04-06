extends TileMap

var image

# Called when the node enters the scene tree for the first time.
func _ready():
	#var image_texture = ImageTexture.new()
	image = Image.new()
	image.load('res://assets/gfx/grass_tint.png')
	image.lock()

	
	#modulate = image.get_pixel(0, 10)
	
  #image_texture.create_from_image(image, 0)
  #self.texture = image_texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var tint = G.physical_player.position.y
	
	tint = tint *0.1
	
	#tint += 300
	
	#print(tint)
	
	if tint > 255:
		tint = 255
	if tint < 0:
		tint = 0
	
	#modulate = image.get_pixel(0, tint)
