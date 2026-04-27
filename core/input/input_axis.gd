extends Node
class_name InputAxis

signal changed(new_value: float)

@export var input := 0.0

@export var positive: StringName
@export var negative: StringName

func _process(_dt):
	if not is_multiplayer_authority(): return
	var new_input = Input.get_axis(negative, positive)
	if new_input != input:
		input = new_input
		_set_input.rpc(new_input)

@rpc("authority", "call_local", "reliable")
func _set_input(val: float):
	input = val
	changed.emit(input)
