
class_name State
extends Node

var state_machine = null


# Called when the node enters the scene tree for the first time.

func inner_unhandled_input(_event: InputEvent) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func inner_process(_delta: float) -> void:
	pass
	
func inner_physics_process(_delta: float) -> void:
	pass

func enter(_msg: Dictionary={}):
	pass
	
func exit():
	pass
