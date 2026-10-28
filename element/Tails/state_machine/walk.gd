extends StateTails

## Идёт шагом, иногда переходит на бег или прыгает.

func enter(_msg: Dictionary = {}) -> void:
	super()
	tails.speed_target = tails.WALK_SPEED
	if tails.desired_dir == 0:
		tails.desired_dir = 1 if randf() > 0.5 else -1
	state_timer = randf_range(1.2, 2.4)

func inner_physics_process(delta: float) -> void:
	tails.apply_movement(delta)
	tails.animation.play("walk")

	if not tails.is_on_floor():
		state_machine.change_to("Air")
		return

	# Стена или край платформы — разворачиваемся и идём дальше.
	if tails.is_on_wall() or not tails.has_floor_ahead():
		tails.desired_dir *= -1
		return

	# Иногда срывается на бег.
	if randf() < 0.008:
		state_machine.change_to("Run")
		return

	# Иногда прыгает (только если впереди есть пол).
	if randf() < 0.015:
		state_machine.change_to("Air", {do_jump = true})
		return

	state_timer -= delta
	if state_timer <= 0.0:
		state_machine.change_to("Idle")
