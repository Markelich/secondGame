class_name Mighty
extends CharacterBody2D

@onready var animation = $AnimatedSprite2D
var state_machine: Node

const SPEED: float =  80.0
const ACCELETATION: float = 300
const JUMP_VELOCITY = -550

var desired_dir: int = 0       # Куда враг ХОЧЕТ идти (-1, 0, 1)
var input_buffer: Array[int] = [] # Буфер задержки реакции
@export var reaction_frames: int = 6 # Задержка (в кадрах)

func _ready() -> void:
	# Заполняем буфер нулями при старте
	for i in range(reaction_frames):
		input_buffer.append(0)

# ... (твой update_facing остается без изменений)

# Новая функция для применения физики (вызывается из состояний)
func apply_movement(target_dir: int, delta: float) -> void:
	# 1. Задержка реакции
	input_buffer.append(target_dir)
	var delayed_dir = input_buffer.pop_front()
	
	# 2. Шум ввода (живые руки)
	var noisy_dir = delayed_dir
	if noisy_dir != 0:
		if randf() < 0.02:
			noisy_dir = 0 # Дрогнула рука
		elif randf() < 0.01:
			noisy_dir = -delayed_dir # Случайно нажал не туда
			
	# 3. Применяем скорость с ускорением
	var target_speed = noisy_dir * SPEED
	
	if noisy_dir != 0:
		velocity.x = move_toward(velocity.x, target_speed, ACCELETATION * delta)
	else:
		# Тормозим чуть быстрее, чем разгоняемся
		velocity.x = move_toward(velocity.x, 0.0, (ACCELETATION * 10.5) * delta)

	# Гравитация (если платформер)
	if not is_on_floor():
		velocity.y += 980.0 * delta # Замени на свою гравитацию проекта
		
	move_and_slide()
	update_facing()

func update_facing() -> void:
	
	if velocity.x < 0:
		animation.set_flip_h(true)
		animation.position.x = 0
	elif velocity.x > 0:
		animation.set_flip_h(false)
		animation.position.x = 0




func _on_mighty_colision_area_entered(area: Area2D) -> void:
	print(area.owner.name) # Replace with function body.
