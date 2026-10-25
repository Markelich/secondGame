extends StateMighty




var walk_time: float = 0.0

func enter(_msg: Dictionary = {}) -> void:
	super()
	walk_time = 0.0
	
	# Выбираем направление движения. 
	# Если пришел сигнал извне — берем его, иначе рандом.
	if _msg.has("dir"):
		mighty.desired_dir = _msg["dir"]
	else:
		mighty.desired_dir = 1 if randf() > 0.5 else -1

func inner_physics_process(_delta: float) -> void:
	# Тело идет в заданном направлении
	mighty.apply_movement(mighty.desired_dir, _delta)
	mighty.animation.play("run")	
	walk_time += _delta
	
	# ЖИВОСТЬ: Проверяем, не пора ли остановиться (раз в 2-4 секунды)
	# Шанс остановки повышается со временем ходьбы
	if randf() < 0.005 or walk_time > 2.0:
		state_machine.change_to("Idle")
	
	# ЖИВОСТЬ: Столкнулся со стеной или краем платформы? Разворачиваемся!
	if mighty.is_on_wall():
		mighty.desired_dir *= -1
		state_machine.change_to("Idle", {"reason": "wall"})
