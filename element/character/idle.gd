extends StatePlayer

func enter(_msg: Dictionary={}):
	player.velocity = Vector2.ZERO
	
func inner_physics_process(_delta: float) -> void:
	if not player.is_on_floor():
		state_machine.change_to("Air")
	if Input.is_action_just_pressed("ui_accept"):
		state_machine.change_to("Air", {do_jump = true})
