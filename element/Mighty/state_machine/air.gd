extends StateMighty

func enter(_msg: Dictionary={}):
	if _msg.has("do_jump"):
		mighty.velocity.y = mighty.JUMP_VELOCITY
	

func inner_physics_process(_delta: float) -> void:
	if Input.is_action_pressed("ui_accept") and mighty.velocity.y < 0:
		mighty.velocity += mighty.get_gravity() * 0.88 * _delta
	elif mighty.velocity.y >= 0:
		mighty.velocity += mighty.get_gravity() * 1.7 * _delta
	else: 
		mighty.velocity += mighty.get_gravity() * 3.7 * _delta



	mighty.animation.play("jump")	

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		mighty.velocity.x = move_toward(mighty.velocity.x, mighty.SPEED * direction, mighty.ACCELETATION * _delta)
	else:
		mighty.velocity.x = move_toward(mighty.velocity.x, 0, mighty.ACCELETATION * _delta)
	
	
	mighty.update_facing()

	mighty.move_and_slide()


	if mighty.is_on_floor():
		if mighty.velocity.x == 0:
			state_machine.change_to("Idle")
		else:
			state_machine.change_to("Run")
