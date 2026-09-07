extends StatePlayer


func enter(_msg: Dictionary={}):
	$"../../debugdata/VBox/Label3".text = name
	
func  inner_physics_process(_delta: float) -> void:
	if not player.is_on_floor():
		state_machine.change_to("Air")
	
	if Input.is_action_just_pressed("ui_accept"):
		state_machine.change_to("Air", {do_jump = true})
	
	var direction := Input.get_axis("ui_left", "ui_right")
	$"../../debugdata/VBox/Label".text = str(player.velocity)
	$"../../debugdata/VBox/Label2".text = str(direction)
	if direction:
		player.velocity.x = lerp(player.velocity.x, player.SPEED * direction, 0.2)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED/15)
	print(player.velocity)	
	player.move_and_slide()
	
	if player.velocity.x == 0 and direction == 0:
		state_machine.change_to("Idle")
