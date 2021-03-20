extends KinematicBody2D

export (int) var speed = 100

var velocity = Vector2()
var is_moving
var current_direction
var Global


# Called when the node enters the scene tree for the first time.
func _ready():
	Global = get_tree().get_current_scene().get_node("Global")
	current_direction = "walk_down"
	set_current_item_icon(null)
	
	$DayNightLantern.play("DayNightLantern")

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
	$DayNightLantern.seek(Global.time.get_decimal_hours(), true)
	get_input()
	velocity = move_and_slide(velocity)
	
	if is_moving:
		$ItemBobbingAnimation.play("ItemCarried")
		$AnimatedSprite.play(current_direction)
	else:
		$ItemBobbingAnimation.stop()
		$AnimatedSprite.play(current_direction + "_idle")

func save():
	var save_dict = {
		"name" : name,
		"current_direction": current_direction,
		"posX": position.x,
		"posY": position.y,
	}
	return save_dict

func restore(data):
	current_direction = data["current_direction"]
	position.x = data["posX"]
	position.y = data["posY"]
