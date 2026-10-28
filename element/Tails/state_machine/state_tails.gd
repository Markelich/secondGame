class_name StateTails
extends State

# База состояний бота Tails.

var tails: Tails
var state_timer: float = 0.0

func _ready() -> void:
	tails = owner as Tails

func enter(_msg: Dictionary = {}) -> void:
	state_timer = 0.0
