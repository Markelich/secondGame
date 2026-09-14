extends StatePlayer

func enter(_msg: Dictionary={}):
	$"../../debugdata/VBox/Label3".set_text(name)
	if _msg.has("do_jump"):
		player.velocity.y = player.JUMP_VELOCITY

	

func inner_physics_process(_delta: float) -> void:
	
	if Input.is_action_pressed("ui_accept") and player.velocity.y < 0:
		player.velocity += player.get_gravity() * _delta
	else: player.velocity += player.get_gravity()*2.1 * _delta 
	
	if player.velocity.y < -100:
		player.animation.play("jump")
	elif player.velocity.y >= -100 and player.velocity.y <= 100:
		player.animation.play("jumptofall")
	elif player.velocity.y > 100:
		player.animation.play("fall")
		


	
	
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction:
		player.velocity.x = lerp(player.velocity.x, player.SPEED * direction, 0.2)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED/20)
	
	
	if direction < 0:
		player.animation.set_flip_h(true)
	elif direction > 0:
		player.animation.set_flip_h(false)

	player.move_and_slide()
	
	$"../../debugdata/VBox/Label".set_text(str(player.velocity))
	$"../../debugdata/VBox/Label2".set_text(str(direction))
	
	
	if player.is_on_floor():
		if player.velocity.x == 0:
			state_machine.change_to("Idle")
		else:
			state_machine.change_to("Run")
	
	
