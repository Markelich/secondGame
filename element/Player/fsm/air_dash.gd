extends StatePlayer

## Рывок в воздухе (air dash).
##
## Нажатие «вниз» в прыжке даёт горизонтальный рывок: скорость мгновенно
## подскакивает до AIR_DASH_SPEED, а гравитация на время рывка отключается —
## персонаж «протягивается» по воздуху. Даётся один раз за прыжок.

var _direction: float = 0.0
var _time_left: float = 0.0


func enter(_msg: Dictionary = {}) -> void:
	$"../../debugdata/VBox/Label3".text = name

	# Рывок в сторону ввода, а если клавиши не тронуты — в сторону взгляда.
	_direction = Input.get_axis("ui_left", "ui_right")
	if is_zero_approx(_direction):
		_direction = -1.0 if player.animation.flip_h else 1.0

	player.air_dash_used = true
	_time_left = player.AIR_DASH_TIME

	# Вертикальную скорость гасим: рывок идёт строго по горизонтали.
	player.velocity = Vector2(player.AIR_DASH_SPEED * _direction, 0.0)

	player.animation.play("jump")
	player.update_facing()


func inner_physics_process(delta: float) -> void:
	_time_left -= delta

	# Пока рывок активен, вниз не тянет.
	#player.velocity.y = 0.0

	player.move_and_slide()

	if player.is_on_floor():
		if absf(player.velocity.x) < 1.0:
			state_machine.change_to("Idle")
		else:
			state_machine.change_to("Run")
		return

	# Врезались в стену — рывок прерывается.
	if player.is_on_wall():
		player.velocity.x = 0.0
		state_machine.change_to("Air", {no_coyote = true})
		return

	if _time_left <= 0.0:
		# Возвращаемся в обычный полёт, сохраняя набранную скорость.
		state_machine.change_to("Air", {no_coyote = true})
