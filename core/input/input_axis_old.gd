extends Node

signal updated(vec: Vector2)
signal process_input(vec: Vector2)

@export var positive_x: InputEventAction
@export var negative_x: InputEventAction
@export var positive_y: InputEventAction
@export var negative_y: InputEventAction
@export var deadzone := -1.0

var _vector: Vector2

func _process(dt):
	var vec = Input.get_vector(negative_x.action, positive_x.action, negative_y.action, positive_y.action, deadzone)
	if vec != _vector:
		_vector = vec
		updated.emit(vec)
	process_input.emit(vec)
