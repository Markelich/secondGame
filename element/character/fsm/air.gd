extends StatePlayer

@onready var bufJump = $"../../TimerBufferJump"
@onready var coyoteTimer = $"../../CoyoteTimer"

func enter(_msg: Dictionary={}):
	$"../../debugdata/VBox/Label3".set_text(name)
	if _msg.has("do_jump"):
		player.velocity.y = player.JUMP_VELOCITY
	else:
		coyoteTimer.start()
	

func inner_physics_process(_delta: float) -> void:
	
	if Input.is_action_pressed("ui_accept") and player.velocity.y < 0:
		player.velocity += player.get_gravity() * 0.88 * _delta
	elif player.velocity.y >= 0:
		player.velocity += player.get_gravity() * 2.5 * _delta
	else: 
		player.velocity += player.get_gravity() * 3.7 * _delta

	
	if Input.is_action_just_pressed("ui_accept") and coyoteTimer.time_left > 0:
		player.velocity.y = player.JUMP_VELOCITY
		print("Коёт", coyoteTimer.time_left)
		coyoteTimer.stop()
	elif Input.is_action_just_pressed("ui_accept"):
		print("Нажал на прыжок в прыжке")
		bufJump.start()

		
	#if player.velocity.y < -100:
		#player.animation.play("jump")
	#elif player.velocity.y >= -100 and player.velocity.y <= 100:
		#player.animation.play("jumptofall")
	#elif player.velocity.y > 100:
		#player.animation.play("fall")
	player.animation.play("jump")	
	
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction:
		player.velocity.x = move_toward(player.velocity.x, player.SPEED * direction, player.ACCELETATION * _delta)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.ACCELETATION * _delta)
	
	
	if player.velocity.x < 0:
		player.animation.set_flip_h(true)
	elif player.velocity.x > 0:
		player.animation.set_flip_h(false)

	player.move_and_slide()
	
	$"../../debugdata/VBox/Label".set_text(str(player.velocity))
	$"../../debugdata/VBox/Label2".set_text(str(direction))
	
	
	if player.is_on_floor() and bufJump.time_left > 0:
		player.velocity.y = player.JUMP_VELOCITY
	elif player.is_on_floor():
		if player.velocity.x == 0:
			state_machine.change_to("Idle")
		else:
			state_machine.change_to("Run")
		 		
	
	
	
