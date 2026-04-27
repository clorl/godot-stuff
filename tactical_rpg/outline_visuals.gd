@tool
extends Node

@export var material: ShaderMaterial
@export var targets: Array[GeometryInstance3D]

@export var enabled = false:
	set(v): enabled = v; set_enabled(v)

func _ready():
	enabled = enabled

func set_enabled(val: bool):
	for t in targets:
		t.material_overlay = material if val else null

func _exit_tree():
	for t in targets:
		t.material_overlay = null
