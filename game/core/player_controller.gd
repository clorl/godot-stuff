class_name PlayerController
extends Node

@export var move := Vector2()
@export var cycle_sprite := false

func _process(_dt):
	if is_multiplayer_authority():
		move = Input.get_vector("move_left", "move_right", "move_front", "move_back")
		cycle_sprite = Input.is_action_just_pressed("cycle_sprite")
		Debug.set_text("input_move", move)
		Debug.set_text("input_sprite", cycle_sprite)
