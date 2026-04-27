class_name PlayerController
extends MultiplayerSynchronizer

@export var move := Vector2()
@export var cycle_sprite := false

func _process(_dt):
	if is_multiplayer_authority():
		move = Input.get_vector("move_left", "move_right", "move_front", "move_back")
		cycle_sprite = Input.is_action_just_pressed("cycle_sprite")

func _input(e):
	if e is InputEventMouseButton and e.pressed:
		pass
