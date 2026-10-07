extends StatePlayer


var _deceleration: float = 0.0
var _was_braking: bool = false
var _braking_finished: bool = true
var is_turning: bool

func enter(_msg: Dictionary = {}) -> void:
	$"../../debugdata/VBox/Label3".text = name
	if not player.animation.animation_finished.is_connected(_on_anim_finished):
		player.animation.animation_finished.connect(_on_anim_finished)
	_braking_finished = true
	_was_braking = false
	
	



func _play_if_not(anim: StringName) -> void:
	print(anim)
	if player.animation.animation != anim:
		player.animation.play(anim)
		if anim == "return":
			print(1234567)
		elif anim == "startbreaking" and !_was_braking:
			#print(anim)
			_deceleration = abs(player.velocity.x) / maxf(player.BRAKE_TIME, 0.01)
			_deceleration = maxf(_deceleration, 100.0)
			_braking_finished = false
			_was_braking = true

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
		if _braking_finished:
			_play_if_not("startbreaking")
		if _was_braking:
			player.velocity.x = move_toward(player.velocity.x, 0, _deceleration * _delta)
	#print(is_turning)	D
	elif _braking_finished:	
		if abs(player.velocity.x) <= player.SPEED_POINT_TOFAST:
			
			_play_if_not("run")
		elif abs(player.velocity.x) > player.SPEED_POINT_TOFAST:
			_play_if_not("fastrun")

		if direction:
			player.velocity.x = move_toward(player.velocity.x, player.SPEED * direction, player.ACCELETATION * _delta)
		else:
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
	$"../../debugdata/VBox/Label4".text = str(is_turning)
	$"../../debugdata/VBox/Label5".text = str(player.animation.animation)

	if abs(player.velocity.x) < 1.0 and direction == 0:
		state_machine.change_to("Idle")

func _on_anim_finished() -> void:
	if player.animation.animation == "return":
		_braking_finished = true
		_was_braking = false
	elif player.animation.animation == "startbreaking":
		print(987654)
		if !_braking_finished and is_turning:
			
			_play_if_not("return")
		#if !_braking_finished and is_turning:
			#_play_if_not("break")
	
