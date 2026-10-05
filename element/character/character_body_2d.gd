class_name Player
extends CharacterBody2D


@onready var animation = $AnimatedSprite2D

const SPEED: float = 900.0
const SPEED_POINT_TOFAST = 300.0
const ACCELETATION: float = 230
const TURN_ACCELERATION: float = 1200.0
const JUMP_VELOCITY = -550
const TURN_RETURN_THRESHOLD: float = 30.0 
