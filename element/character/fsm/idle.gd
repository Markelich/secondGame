extends StatePlayer

func enter(_msg: Dictionary={}):
	player.velocity = Vector2.ZERO
	$"../../debugdata/VBox/Label3".set_text(name)
	
func inner_physics_process(_delta: float) -> void:
	if not player.is_on_floor():
		state_machine.change_to("Air")
	if Input.is_action_just_pressed("ui_accept"):
		state_machine.change_to("Air", {do_jump = true})
	
	if Input.is_action_pressed('ui_left') or Input.is_action_pressed('ui_right'):
		state_machine.change_to("Run")
