extends StatePlayer


var is_turning: bool

func enter(_msg: Dictionary = {}) -> void:
	$"../../debugdata/VBox/Label3".text = name

func _play_if_not(anim: StringName) -> void:
	if player.animation.animation != anim:
		player.animation.play(anim)

func inner_physics_process(_delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if not player.is_on_floor():
		state_machine.change_to("Air")
		return
		
	if Input.is_action_just_pressed("ui_accept"):
		state_machine.change_to("Air", {do_jump = true})
		return

	is_turning = (direction != 0 and sign(direction) != sign(player.velocity.x) and abs(player.velocity.x) > 0.1)
	
	if is_turning:
		state_machine.change_to("Startbreaking")
			
	else:	
		if abs(player.velocity.x) <= player.SPEED_POINT_TO_JOG:
			_play_if_not("walk")
		elif abs(player.velocity.x) > player.SPEED_POINT_TO_JOG and abs(player.velocity.x) < player.SPEED_POINT_TO_RUN:
			_play_if_not("jog")
		elif abs(player.velocity.x) >= player.SPEED_POINT_TO_RUN:
			_play_if_not("run")

		if direction:
			player.velocity.x = move_toward(player.velocity.x, player.SPEED * direction, player.ACCELETATION * _delta)
		else:
			player.velocity.x = move_toward(player.velocity.x, 0, player.ACCELETATION * _delta)
		
		player.update_facing()
	
	if Input.is_action_just_pressed("ui_down") and player.is_on_floor() and absf(player.velocity.x) > 50:
		state_machine.change_to("Spinattack")	

		


	player.move_and_slide()

	if abs(player.velocity.x) < 1.0 and direction == 0:
		state_machine.change_to("Idle")

	
