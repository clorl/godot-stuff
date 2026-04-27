@tool
class_name LookAt3D
extends Node3D

@export var target: Node3D

func _process(_dt):
	if not target: return
	if target.global_position == global_position: return
	target.look_at(global_position)
