extends StatePlayer

func enter(_msg: Dictionary={}):
	$"../../debugdata/VBox/Label3".set_text(name)
	if _msg.has("do_jump"):
		player.velocity.y = player.JUMP_VELOCITY

	

func inner_physics_process(_delta: float) -> void:
	player.velocity += player.get_gravity() * _delta
	
	var direction := Input.get_axis("ui_left", "ui_right")
	$"../../debugdata/VBox/Label2".set_text(str(direction))
	if direction:
		player.velocity.x = lerp(player.velocity.x, player.SPEED * direction, 0.2)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED/15)
	$"../../debugdata/VBox/Label".set_text(str(player.velocity))
	print(player.velocity)

	player.move_and_slide()
	
	if player.is_on_floor():
		if player.velocity.x == 0:
			state_machine.change_to("Idle")
		else:
			state_machine.change_to("Run")
