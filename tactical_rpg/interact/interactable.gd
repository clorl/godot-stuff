extends Node

const SystemType = preload("./system.gd")

var _system: SystemType:
	get:
		return Engine.get_singleton(SystemType.NAME)

signal interacted(node: CollisionObject3D)

@export var target: CollisionObject3D

func _ready():
	if not target:
		target = get_parent()
	assert(target)
	target.mouse_entered.connect(_mouse_entered)
	target.mouse_exited.connect(_mouse_exited)

func _mouse_exited() -> void:
	for c in get_children():
		c.set("enabled", false)
		c.set("visible", false)
	if _system and _system.has_method("_set_interaction_candidate"): _system._set_interaction_candidate(self, false)

func _mouse_entered() -> void:
	for c in get_children():
		c.set("enabled", true)
		c.set("visible", true)
	if _system and _system.has_method("_set_interaction_candidate"): _system._set_interaction_candidate(self, true)

func interact():
	interacted.emit(target)
