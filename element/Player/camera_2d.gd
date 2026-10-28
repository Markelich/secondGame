extends Camera2D

## Камера главного персонажа.
##
## Модель движения: у камеры есть собственная скорость и ограниченное ускорение.
## Она не «приклеена» к персонажу и не тянется к нему пропорционально расстоянию —
## она разгоняется в его сторону, как тело с массой, но с «критическим»
## торможением: желаемая скорость пропорциональна расстоянию до цели, поэтому
## камера плавно подъезжает и не проскакивает (никакого дрожания).

@export var target_path: NodePath = ^".."
@export var state_machine_path: NodePath = ^"../FSM"
@export var air_state_name: StringName = &"Air"

@export_group("Переход между режимами")
## За сколько секунд камера переходит из воздушного режима в наземный и обратно.
## 0.15–0.25 — плавно, без рывка. 0 — мгновенное переключение (как было).
@export var ground_blend_time: float = 0.2

@export_group("Наземное следование")
## Максимальное ускорение камеры на земле (px/s²).
## Вместе с ground_max_speed задаёт «жёсткость»: stiffness = accel / max_speed.
@export var ground_accel: float = 10800.0
## Максимальная скорость камеры на земле (px/s).
## Большое отставание — камера едет на этой скорости, малое — плавно тормозит.
@export var ground_max_speed: float = 900.0
## Торможение внутри мёртвой зоны (на земле deadzone=0, поэтому не используется).
@export var ground_brake: float = 300000.0
## Мёртвая зона на земле. Небольшая (4–8 px) — убирает микро-дёрганье
## и не даёт камере бросаться на мелкие смещения персонажа.
@export var ground_deadzone: float = 6.0



@export_group("Воздушное следование")
## Ускорение по вертикали в воздухе. Маленькое — камера «провожает» прыжок.
@export var air_accel_y: float = 8800.0
## Максимальная вертикальная скорость камеры при большом отставании.
@export var air_max_speed_y: float = 1000.0
@export var air_brake_y: float = 800.0

## Ускорение по горизонтали в воздухе. Заметно жёстче, чтобы не терять персонажа.
@export var air_accel_x: float = 6800.0
@export var air_max_speed_x: float = 900.0
@export var air_brake_x: float = 200.0

@export_group("Мёртвая зона в воздухе")
## Насколько персонаж должен уйти по вертикали, чтобы камера начала разгон.
@export var air_deadzone_y: float = 12.0
## То же по горизонтали (0 — реагировать сразу).
@export var air_deadzone_x: float = 0.0

## Текущая позиция камеры (== global_position, но храним отдельно для ясности).
var _pos: Vector2
## Текущая скорость камеры.
var _vel: Vector2 = Vector2.ZERO
## 0 — полностью воздушный режим, 1 — полностью наземный.
var _ground_blend: float = 1.0
var _target: Node2D
var _state_machine: Node


func _ready() -> void:
	_target = get_node_or_null(target_path) as Node2D
	_state_machine = get_node_or_null(state_machine_path)

	top_level = true

	if _target != null:
		_pos = _target.global_position
		global_position = _pos
		_vel = Vector2.ZERO
		# Стартуем в наземном режиме (персонаж ведь стоит на земле).
		_ground_blend = 0.0 if is_airborne() else 1.0


func _physics_process(delta: float) -> void:
	if _target == null:
		return

	# Плавно переключаем режим — это ключ к отсутствию рывка при приземлении.
	var target_blend: float = 0.0 if is_airborne() else 1.0
	if ground_blend_time > 0.0:
		_ground_blend = move_toward(_ground_blend, target_blend, delta / ground_blend_time)
	else:
		_ground_blend = target_blend

	# Смешиваем параметры по каждой оси.
	# X: воздушные и наземные значения могут отличаться.
	var accel_x: float = lerpf(air_accel_x, ground_accel, _ground_blend)
	var max_x: float = lerpf(air_max_speed_x, ground_max_speed, _ground_blend)
	var brake_x: float = lerpf(air_brake_x, ground_brake, _ground_blend)
	var dead_x: float = lerpf(air_deadzone_x, ground_deadzone, _ground_blend)

	# Y: на земле используем те же ground_accel/max_speed (симметрично X),
	# в воздухе — отдельные вертикальные параметры.
	var accel_y: float = lerpf(air_accel_y, ground_accel, _ground_blend)
	var max_y: float = lerpf(air_max_speed_y, ground_max_speed, _ground_blend)
	var brake_y: float = lerpf(air_brake_y, ground_brake, _ground_blend)
	var dead_y: float = lerpf(air_deadzone_y, ground_deadzone, _ground_blend)

	var desired: Vector2 = _target.global_position

	_vel = _accelerate_axis(
		_vel, desired - _pos, delta,
		Vector2(accel_x, accel_y),
		Vector2(max_x, max_y),
		Vector2(brake_x, brake_y),
		Vector2(dead_x, dead_y)
	)

	_pos += _vel * delta
	global_position = _pos


## Персонаж сейчас в воздухе?
func is_airborne() -> bool:
	if _state_machine == null:
		return false

	var current_state: Node = _state_machine.state
	if current_state == null:
		return false

	return String(current_state.name) == String(air_state_name)


## Разгоняет скорость камеры по каждой оси независимо.
func _accelerate_axis(
	vel: Vector2,
	offset: Vector2,
	delta: float,
	accel: Vector2,
	max_speed: Vector2,
	brake: Vector2,
	deadzone: Vector2
) -> Vector2:
	var result := vel
	result.x = _axis_step(vel.x, offset.x, delta, accel.x, max_speed.x, brake.x, deadzone.x)
	result.y = _axis_step(vel.y, offset.y, delta, accel.y, max_speed.y, brake.y, deadzone.y)
	return result


## Один шаг по одной оси.
func _axis_step(
	v: float, offset: float, delta: float,
	accel: float, max_speed: float, brake: float, deadzone: float
) -> float:
	# Внутри мёртвой зоны плавно гасим скорость.
	if absf(offset) <= deadzone:
		return move_toward(v, 0.0, brake * delta)

	# Желаемая скорость пропорциональна расстоянию, но ограничена max_speed.
	# На большом расстоянии — едем на max_speed; на малом — плавно тормозим,
	# поэтому камера не проскакивает цель.
	var stiffness: float = accel / maxf(max_speed, 0.001)
	var v_desired: float = clampf(offset * stiffness, -max_speed, max_speed)

	# Ограничиваем ускорение — камера не может мгновенно менять скорость.
	return move_toward(v, v_desired, accel * delta)
