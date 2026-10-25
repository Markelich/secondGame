class_name Player
extends CharacterBody2D


@onready var animation = $AnimatedSprite2D

const SPEED: float = 900.0
const SPEED_POINT_TO_JOG = 300.0
const SPEED_POINT_TO_RUN = 500.0
const ACCELETATION: float = 430
const SPIN_ACCELERATION: float = 180.0
const BRAKE_TIME: float = 0.2
const JUMP_VELOCITY = -550
const TURN_RETURN_THRESHOLD: float = 30.0

func play_if_not(anim: StringName) -> void:
	if animation.animation != anim:
		animation.play(anim)

func update_facing() -> void:
	if velocity.x < 0:
		animation.set_flip_h(true)
		animation.position.x = 0
	elif velocity.x > 0:
		animation.set_flip_h(false)
		animation.position.x = 0







func _on_player_colision_area_entered(area: Area2D) -> void:
	print(area.owner.name) # Replace with function body.
