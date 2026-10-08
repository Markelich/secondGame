extends StatePlayer

var _deceleration: float = 0.0
var direction


func _play_if_not(anim: StringName) -> void:
	print(anim)
	if player.animation.animation != anim:
		player.animation.play(anim)

func enter(_msg: Dictionary = {}) -> void:
	_play_if_not("startbreaking")
	_deceleration = abs(player.velocity.x) / maxf(player.BRAKE_TIME, 0.01)
	_deceleration = maxf(_deceleration, 100.0)
	$"../../debugdata/VBox/Label3".set_text(name)
	if not player.animation.animation_finished.is_connected(_on_anim_finished):
		player.animation.animation_finished.connect(_on_anim_finished)


func inner_physics_process(_delta: float) -> void:
	direction = Input.get_axis("ui_left", "ui_right")
	if not player.is_on_floor():
		state_machine.change_to("Air")
		return
	
	if Input.is_action_just_pressed("ui_accept"):
		state_machine.change_to("Air", {do_jump = true})
	
	if (direction != 0 and signf(direction) != signf(player.velocity.x)):
		player.velocity.x = move_toward(player.velocity.x, 0, _deceleration * _delta)
	#elif (direction != 0 and signf(direction) == signf(player.velocity.x)):
		#state_machine.change_to("Run")
	elif direction == 0:
		player.velocity.x = move_toward(player.velocity.x, 0, player.ACCELETATION * _delta)
	
	if player.velocity.x == 0 and player.animation.animation == "break":
		_on_anim_finished()
	
	player.move_and_slide()



func _on_anim_finished() -> void:
	if player.animation.animation == "startbreaking":
		if (direction != 0 and sign(direction) != sign(player.velocity.x)):
			print("return")
			_play_if_not("return")
		else :
			print("brake")
			_play_if_not("break")
			
			
	elif player.animation.animation == "break":
		if (direction != 0 and sign(direction) != sign(player.velocity.x)):
			print("return")
			_play_if_not("return")
		elif (direction != 0 and sign(direction) == sign(player.velocity.x)) or direction == 0:
			state_machine.change_to("Run")
		elif direction == 0:
			print("brake")
			_play_if_not("break")	
			
	elif player.animation.animation == "return":
		state_machine.change_to("Run")
		
		



func exit() -> void:
	pass
