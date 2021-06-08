extends KinematicBody2D

export (int) var speed = 100

var velocity = Vector2()
var is_moving
var current_direction
var stamina = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	current_direction = "walk_down"
	set_current_item_icon(null)
	
	$DayNightLantern.play("DayNightLantern")
	$Ambiance.show()
	$CanvasModulate.show()

func get_input():
	velocity = Vector2()
	is_moving = false
	
	"""
	if Input.is_action_just_pressed("ui_focus_next"):
		if not self.menu_visibility:
			print("show menu")
			get_node("UserInterface").show()
			get_node("CanvasModulate").hide()
		else:
			print("hide menu")
			get_node("UserInterface").hide()
			get_node("CanvasModulate").show()
		
		self.menu_visibility = !self.menu_visibility
	"""
	
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		current_direction = "walk_down"
		is_moving = true
		
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		current_direction = "walk_up"
		is_moving = true
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		current_direction = "walk_right"
		is_moving = true
		
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		current_direction = "walk_left"
		is_moving = true
	
	
	velocity = velocity.normalized() * speed

func set_current_item_icon(item):
	if item != null:
		$Icon.set_texture(item.i_image)
		$Icon.show()
	else:
		$Icon.hide()

func _physics_process(_delta):
	$DayNightLantern.seek(G.time.get_decimal_hours(), true)
	get_input()
	velocity = move_and_slide(velocity)
	
	if is_moving:
		$ItemBobbingAnimation.play("ItemCarried")
		$AnimatedSprite.play(current_direction)
	else:
		$ItemBobbingAnimation.stop()
		$AnimatedSprite.play(current_direction + "_idle")

func _process(delta):
	var stamina_drain_rate = 0.5
	if is_moving:
		stamina_drain_rate = 0.9
	
	stamina -= G.time.dspeed * stamina_drain_rate

func set_weather(weather):
	# Reset weather
	$Weather/Fog.hide()
	$Weather/Rain.hide()
	$Weather/Snow.hide()
	$Weather/Sun.hide()

	if weather == G.weather.weather.SNOW:
		$Weather/Snow.show()
	if weather == G.weather.weather.RAIN:
		$Weather/Rain.show()
	if weather == G.weather.weather.STORM:
		$Weather/Fog.show()
		$Weather/Rain.show()
	if weather == G.weather.weather.FOG:
		$Weather/Fog.show()
	if weather == G.weather.weather.SUN:
		$Weather/Sun.show()
	if weather == G.weather.weather.CLEAR:
		pass
		

func save():
	var save_dict = {
		"name" : name,
		"current_direction": current_direction,
		"posX": position.x,
		"posY": position.y,
		"stamina": stamina
	}
	return save_dict

func restore(data):
	current_direction = data["current_direction"]
	position.x = data["posX"]
	position.y = data["posY"]
	stamina = data["stamina"]
