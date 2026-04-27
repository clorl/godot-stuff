class_name InputVector
extends Node

signal changed(new_value: Vector2)

@export var input := Vector2()

@export var x_positive: StringName
@export var x_negative: StringName
@export var y_positive: StringName
@export var y_negative: StringName

func _process(_dt):
	if not is_multiplayer_authority(): return
	var new_input = Input.get_vector(x_negative, x_positive, y_negative, y_positive)
	if new_input != input:
		input = new_input
		_set_input.rpc(new_input)

@rpc("authority", "call_local", "reliable")
func _set_input(val: Vector2):
	input = val
	changed.emit(input)
