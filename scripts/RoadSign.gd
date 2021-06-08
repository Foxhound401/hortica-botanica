extends Node2D

export var instructions = "REPLACE WITH INSTRUCTIONS"
export var sign_text = "LOCATION"
export var is_interactive = true

enum ICON {left, right, none}
export (ICON) var sign_icon = ICON.none



# Called when the node enters the scene tree for the first time.
func _ready():
	if len(sign_text) > 14 and sign_icon == ICON.none:
		print("WARNING Text too long for sign post: ", name)
		print("WARNING [", sign_text, "] might not display properly")
	if len(sign_text) > 12 and sign_icon != ICON.none:
		print("WARNING Text too long for sign post: ", name)
		print("WARNING [", sign_text, "] might not display properly")
	$SignInfo.hide()
	$SignInfo/Label.text = sign_text
	$SignInfo/ArrowRight.hide()
	$SignInfo/ArrowLeft.hide()
	if sign_icon == ICON.left:
		$SignInfo/ArrowLeft.show()
	if sign_icon == ICON.right:
		$SignInfo/ArrowRight.show()

func action():
	$SignInfo.show()
	yield(get_tree().create_timer(3), "timeout")
	$SignInfo.hide()
	$Area2D.update_instructions()

