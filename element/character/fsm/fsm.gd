class_name StateMachine

extends Node

@export var start_state: NodePath

@onready var state: State = get_node(start_state)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(111)
	for child in get_children():
		child.state_machine = self
	state.enter()
	
func _unhandled_input(event: InputEvent) -> void:
	state.inner_unhandled_input(event)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	state.inner_process(delta)


func _physics_process(delta: float) -> void:
	state.inner_physics_process(delta)
	
func change_to(target_state: String, _msg: Dictionary={}):
	if not has_node(target_state):
		print("Trying get wrong state: " + target_state)
		return
	else:
		state.exit()
		state = get_node(target_state)
		state.enter(_msg)
		print("State" + state.name)
