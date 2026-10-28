class_name Tails
extends CharacterBody2D

## Небольшой бот: сам решает, когда стоять, идти, бежать или прыгать.
## Машина состояний — общий компонент components/fsm.

@onready var animation = $AnimatedSprite2D

var state_machine: Node

const WALK_SPEED: float = 90.0
const RUN_SPEED: float = 235.0
const ACCELERATION: float = 620.0
const BRAKE: float = 1500.0
const AIR_DRAG: float = 1600.0
const JUMP_VELOCITY: float = -430.0
const GRAVITY: float = 980.0
## Насколько далеко впереди проверяем пол (в пикселях).
const LEDGE_PROBE: float = 20.0

## Куда бот хочет идти: -1 влево, 0 стоять, 1 вправо.
var desired_dir: int = 0
## Целевая скорость текущего состояния (ходьба или бег).
var speed_target: float = WALK_SPEED

func apply_movement(delta: float) -> void:
	if is_on_floor():
		var target_speed: float = desired_dir * speed_target
		var rate: float = ACCELERATION if desired_dir != 0 else BRAKE
		velocity.x = move_toward(velocity.x, target_speed, rate * delta)
	else:
		# В воздухе бот не разгоняется — прыжок получается почти на месте.
		velocity.x = move_toward(velocity.x, 0.0, AIR_DRAG * delta)
		velocity.y += GRAVITY * delta

	move_and_slide()
	update_facing()

func update_facing() -> void:
	if velocity.x < 0:
		animation.flip_h = true
	elif velocity.x > 0:
		animation.flip_h = false

## Есть ли пол впереди. Прямой запрос к физике: результат сразу актуален,
## в отличие от RayCast2D, который обновляется на кадр позже.
func has_floor_ahead() -> bool:
	var side: float = 1.0
	if desired_dir != 0:
		side = float(desired_dir)
	elif not is_zero_approx(velocity.x):
		side = signf(velocity.x)

	var from: Vector2 = global_position + Vector2(LEDGE_PROBE * side, -6.0)
	var to: Vector2 = from + Vector2(0.0, 26.0)
	var query := PhysicsRayQueryParameters2D.create(from, to, 1, [get_rid()])
	return not get_world_2d().direct_space_state.intersect_ray(query).is_empty()

func do_jump() -> void:
	# Прыгаем почти на месте: гасим горизонтальную скорость.
	velocity.x = 0.0
	velocity.y = JUMP_VELOCITY
