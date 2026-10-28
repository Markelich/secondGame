extends StateTails

## Стоит и решает, куда двинуться: пойти шагом или сразу побежать.

func enter(_msg: Dictionary = {}) -> void:
	super()
	tails.desired_dir = 0
	tails.speed_target = tails.WALK_SPEED
	state_timer = randf_range(0.5, 1.4)

func inner_physics_process(delta: float) -> void:
	tails.apply_movement(delta)
	tails.animation.play("idle")

	if not tails.is_on_floor():
		state_machine.change_to("Air")
		return

	state_timer -= delta
	if state_timer > 0.0:
		return

	if randf() < 0.3:
		state_machine.change_to("Run")
	else:
		state_machine.change_to("Walk")
