extends StateMighty

func enter(_msg: Dictionary = {}) -> void:
	super()
	state_timer = randf_range(0.5, 1.5)
	mighty.desired_dir = 0 # Приказываем телу остановиться
	
	
	
func inner_physics_process(_delta: float) -> void:
	mighty.animation.play("idle")
	if not mighty.is_on_floor():
		state_machine.change_to("Air")
	
	mighty.apply_movement(mighty.desired_dir, _delta)
	
	state_timer -= _delta
	
	if state_timer <= 0.0:
		# 20% шанс постоять еще чуть-чуть (человеческая черта)
		if randf() < 0.2:
			state_timer = randf_range(0.3, 0.8)
		else:
			# Решаем идти
			state_machine.change_to("Run")
