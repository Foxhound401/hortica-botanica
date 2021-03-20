extends "res://scripts/IInteractiveNode.gd"

func _ready():
	self.init(get_node("../"))

func _on_character_enter(_body):
	if i_delayed_activation:
		G.ui.set_instructions(get_node("../").instructions, self)
		i_is_inside = true

func _on_character_exit(_body):
	if i_delayed_activation:
		G.ui.reset_instructions(self)
		i_is_inside = false

func _physics_process(_delta):
	if get_node("../").is_interactive and i_is_inside and i_delayed_activation:
		if Input.is_action_pressed("ui_action"):
			print("action trigged by: ", get_node("../").name)
			get_node("../").action()
			G.ui.reset_instructions(self)
