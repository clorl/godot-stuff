extends Area3D
class_name InteractionArea3D

signal interacted

var is_hovered := false

func _ready():
	input_event.connect(_input_event)
	mouse_entered.connect(_mouse_enter)
	mouse_exited.connect(_mouse_exit)

func _input_event(camera: Node, event: InputEvent, event_pos: Vector3, normal: Vector3, shape_idx: int):
	if event.is_action_pressed("interact"):
		print("area input")
		get_viewport().set_input_as_handled()
		interacted.emit()
		if get_parent() is Entity3D:
			SignalBus.entity_interacted.emit(get_parent())

func _mouse_enter():
	is_hovered = true

func _mouse_exit():
	is_hovered = false
