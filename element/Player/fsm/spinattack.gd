extends StatePlayer


func enter(_msg: Dictionary = {}) -> void:
	player.play_if_not('spinattack')
	


func inner_physics_process(_delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	
	
	if not player.is_on_floor():
		state_machine.change_to("Air")
		return
		
	if Input.is_action_just_pressed("ui_accept"):
		state_machine.change_to("Air", {do_jump = true})
		return
	
	
	
	if (direction != 0 and sign(direction) != sign(player.velocity.x) and abs(player.velocity.x) > 0.1):
		player.velocity.x = move_toward(player.velocity.x, player.SPEED * direction, player.SPIN_ACCELERATION*2.2 * _delta)
	elif (direction != 0 and sign(direction) == sign(player.velocity.x) and abs(player.velocity.x) > 0.1):
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPIN_ACCELERATION*0.5 * _delta)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPIN_ACCELERATION * _delta)
	
	if abs(player.velocity.x) <= 5:
		state_machine.change_to('Idle')
	
	player.update_facing()	
	player.move_and_slide()
