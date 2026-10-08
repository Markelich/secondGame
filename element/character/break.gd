extends StatePlayer

var _deceleration: float = 0.0
var _breaking_finished: bool = false


func enter(_msg: Dictionary = {}) -> void:
	
	$"../../debugdata/VBox/Label3".set_text(name)
	_deceleration = abs(player.velocity.x) / maxf(player.BRAKE_TIME, 0.01)
	_deceleration = maxf(_deceleration, 100.0)
	_breaking_finished = false

	if not player.animation.animation_finished.is_connected(_on_anim_finished):
		player.animation.animation_finished.connect(_on_anim_finished)




func _on_anim_finished() -> void:
	if player.animation.animation == "breaking":
		_breaking_finished = true


func inner_physics_process(_delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if not player.is_on_floor():
		player.velocity.y += player.get_gravity().y * _delta
	
	
	if Input.is_action_just_pressed("ui_accept"):
		state_machine.change_to("Air", {do_jump = true})


	if player.velocity.x != 0:
		player.velocity.x = move_toward(player.velocity.x, 0, _deceleration * _delta)

		if player.animation.animation != "breaking":
			player.animation.play("breaking")
		
		player.move_and_slide()
		return

	# velocity.x == 0 — физически остановились
	# Ждём, пока breaking доиграет
	if not _breaking_finished:
		player.move_and_slide()
		return

	# Оба условия выполнены — в Idle
	state_machine.change_to("Run")
	
func exit() -> void:
	pass
