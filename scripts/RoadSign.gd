extends Node2D

var instructions = "Press 'E' to read"
export var sign_text_left = ""
export var sign_text_right = ""
export var is_interactive = true


# Called when the node enters the scene tree for the first time.
func _ready():
	if len(sign_text_left) > 12 or len(sign_text_left) == 0:
		print("WARNING Text too long or non existant for left sign post: ", name)
		print("WARNING [", sign_text_left, "] might not display properly")
	if len(sign_text_right) > 12 or len(sign_text_right) == 0:
		print("WARNING Text too long or non existant for right sign post: ", name)
		print("WARNING [", sign_text_right, "] might not display properly")
	$SignInfo.hide()
	$SignInfo/LabelLeft.text = sign_text_left
	$SignInfo/LabelRight.text = sign_text_right

func action():
	$SignInfo.show()
	yield(get_tree().create_timer(5), "timeout")
	$SignInfo.hide()
	$Area2D.update_instructions()

