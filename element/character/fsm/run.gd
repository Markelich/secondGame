extends StatePlayer


func enter(_msg: Dictionary = {}) -> void:
	$"../../debugdata/VBox/Label3".text = name

	if not player.animation.animation_finished.is_connected(_on_anim_finished):
		player.animation.animation_finished.connect(_on_anim_finished)


func _on_anim_finished() -> void:
	# После завершения breaking — сразу запускаем return
	if player.animation.animation == "breaking":
		player.animation.play("return")


func _play_if_not(anim: StringName) -> void:
	if player.animation.animation != anim:
		player.animation.play(anim)


func inner_physics_process(_delta: float) -> void:
	if not player.is_on_floor():
		state_machine.change_to("Air")
		return

	if Input.is_action_just_pressed("ui_accept"):
		state_machine.change_to("Air", {do_jump = true})
		return

	var direction := Input.get_axis("ui_left", "ui_right")

	var is_turning: bool = (
		direction != 0
		and sign(direction) != sign(player.velocity.x)
		and abs(player.velocity.x) > 1.0
	)

	if direction != 0:
		if is_turning:
			_play_if_not("breaking")
			player.velocity.x = move_toward(
				player.velocity.x, player.SPEED * direction, player.TURN_ACCELERATION * _delta
			)
		else:
			if abs(player.velocity.x) <= player.SPEED_POINT_TOFAST:
				_play_if_not("run")
			else:
				_play_if_not("fastrun")

			player.velocity.x = move_toward(
				player.velocity.x, player.SPEED * direction, player.ACCELETATION * _delta
			)
	else:
		_play_if_not("breaking")
		player.velocity.x = move_toward(player.velocity.x, 0, player.ACCELETATION * _delta)

	if player.velocity.x < 0:
		player.animation.position.x = 0
		player.animation.set_flip_h(true)
	elif player.velocity.x > 0:
		player.animation.set_flip_h(false)
		player.animation.position.x = 0

	player.move_and_slide()
	$"../../debugdata/VBox/Label".text = str(player.velocity)
	$"../../debugdata/VBox/Label2".text = str(direction)

	if player.velocity.x == 0 and direction == 0:
		state_machine.change_to("Idle")
