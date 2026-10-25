class_name StateMighty
extends State

var mighty: Mighty
var state_timer: float = 0.0
# База состояний HeavyShinobi: наследует общий State,
# добавляет только своё — ссылку на персонажа и таймер состояния.
func _ready() -> void:
	mighty = owner as Mighty




func enter(_msg: Dictionary={}):
	state_timer = 0.0
