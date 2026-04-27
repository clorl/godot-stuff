# Component that exposes player inputs
extends Node

signal move_changed(new_value: Vector2)
signal move_tick(value: Vector2)

@export var move_input := Vector2()

func _process(_dt):
	if not is_multiplayer_authority(): return
	var new_input = Input.get_vector("move_left", "move_right", "move_front", "move_back")
	if new_input != move_input:
		move_input = new_input
		_set_move_input.rpc(new_input)
	move_tick.emit(new_input)

@rpc("authority", "call_local", "reliable")
func _set_move_input(val: Vector2):
	move_input = val
	move_changed.emit(move_input)
