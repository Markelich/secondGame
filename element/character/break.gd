extends StatePlayer

var _deceleration: float = 0.0
var direction := Input.get_axis("ui_left", "ui_right")


func enter(_msg: Dictionary = {}) -> void:
	$"../../debugdata/VBox/Label3".set_text(name)
	_deceleration = abs(player.velocity.x) / maxf(player.BRAKE_TIME, 0.01)
	_deceleration = maxf(_deceleration, 100.0)

	
func inner_physics_process(_delta: float) -> void:
	player.animation.play("breaking")
	player.velocity.x = move_toward(player.velocity.x, 0, _deceleration * _delta)
	if abs(player.velocity.x) < 1.0 and direction == 0:
		state_machine.change_to("Idle")
	
		
func _process(delta: float) -> void:
	pass
