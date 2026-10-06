extends StatePlayer

var _was_braking: bool = false
var _braking_finished: bool = true


func enter(_msg: Dictionary = {}) -> void:
	$"../../debugdata/VBox/Label3".text = name
	_braking_finished = true
	_was_braking = false


func _play_if_not(anim: StringName) -> void:
	if player.animation.animation != anim:
		player.animation.play(anim)
		if anim == "breaking":
			_braking_finished = false


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
			state_machine.change_to("Break")
		else:
			if abs(player.velocity.x) <= player.SPEED_POINT_TOFAST:
				player.animation.play("run")
			else:
				player.animation.play("fastrun")

			player.velocity.x = move_toward(
				player.velocity.x, player.SPEED * direction, player.ACCELETATION * _delta
			)
	else:
		player.velocity.x = move_toward(
				player.velocity.x, player.SPEED * 0, player.ACCELETATION * _delta
			)

	if player.velocity.x < 0:
		player.animation.position.x = 0
		player.animation.set_flip_h(true)
	elif player.velocity.x > 0:
		player.animation.set_flip_h(false)
		player.animation.position.x = 0

	player.move_and_slide()
	$"../../debugdata/VBox/Label".text = str(player.velocity)
	$"../../debugdata/VBox/Label2".text = str(direction)

	if abs(player.velocity.x) < 1.0 and direction == 0:
		state_machine.change_to("Idle")
