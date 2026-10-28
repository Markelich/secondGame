extends StateTails

## Полёт: прыжок из Walk/Run или падение с платформы.

func enter(_msg: Dictionary = {}) -> void:
	super()

	if _msg.has("do_jump"):
		tails.do_jump()

func inner_physics_process(delta: float) -> void:
	tails.apply_movement(delta)
	tails.animation.play("jump")

	if not tails.is_on_floor():
		return

	if tails.desired_dir != 0:
		state_machine.change_to("Walk")
	else:
		state_machine.change_to("Idle")
