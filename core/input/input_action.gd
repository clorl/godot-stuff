extends Node
class_name InputAction

signal changed(new_value: bool)
signal just_pressed()

@export var input := false

@export var action: StringName

func _process(_dt):
	if Input.is_action_just_pressed(action):
		just_pressed.emit()
	if not is_multiplayer_authority(): return
	var new_input = Input.is_action_pressed(action)
	if new_input != input:
		input = new_input
		_set_input.rpc(new_input)

@rpc("authority", "call_local", "reliable")
func _set_input(val: bool):
	input = val
	changed.emit(input)
