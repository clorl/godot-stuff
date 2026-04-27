@tool
class_name LookAt3D
extends Node3D

@export var target: Node3D

func _process(_dt):
	if not target: return
	if target.global_position == global_position: return
	target.look_at(global_position)

func set_target(node: Node3D):
	print(str(node))
	target = node

func move_to(node: Node3D):
	global_position = node.global_position
