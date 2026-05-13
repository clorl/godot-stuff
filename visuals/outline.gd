@tool
extends Node3D

@export var shader: ShaderMaterial
@export var targets: Array[GeometryInstance3D]:
	set(v): targets = v; _ready()

@export var color: Color:
	set(v): color = v; _update_params()
@export var thickness: float:
	set(v): thickness = v; _update_params()

func _ready():
	assert(shader)
	assert(targets)
	assert(targets.size())
	shader = shader.duplicate_deep()
	for t in targets:
		t.material_overlay = shader
	visible = true
	_update_params()

func _exit_tree():
	for t in targets:
		if t.material_overlay == shader:
			t.material_overlay = null

func _update_params():
	for t in targets:
		t.material_overlay.set_shader_parameter("visible", visible)
		t.material_overlay.set_shader_parameter("outline_color", color)
		t.material_overlay.set_shader_parameter("outline_width_px", thickness)

func _notification(what):
	if what == NOTIFICATION_VISIBILITY_CHANGED:
		_update_params()
