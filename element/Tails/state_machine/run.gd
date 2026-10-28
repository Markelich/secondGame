extends StateTails

## Бежит, пока не кончится таймер или пока впереди не окажется край.

func enter(_msg: Dictionary = {}) -> void:
	super()
	tails.speed_target = tails.RUN_SPEED
	if tails.desired_dir == 0:
		tails.desired_dir = 1 if randf() > 0.5 else -1
	state_timer = randf_range(0.8, 1.8)

func inner_physics_process(delta: float) -> void:
	tails.apply_movement(delta)
	tails.animation.play("run")

	if not tails.is_on_floor():
		state_machine.change_to("Air")
		return

	# Стена или край платформы — разворачиваемся.
	if tails.is_on_wall() or not tails.has_floor_ahead():
		tails.desired_dir *= -1
		return

	# На бегу чаще прыгает.
	if randf() < 0.02:
		state_machine.change_to("Air", {do_jump = true})
		return

	state_timer -= delta
	if state_timer <= 0.0:
		state_machine.change_to("Walk")
