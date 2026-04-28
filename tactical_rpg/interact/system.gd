extends Node
class_name InteractionSystem

signal interacted(node: CollisionObject3D)

var _interaction_candidates : Dictionary[String, Node] = {}

func _enter_tree():
	Game.register_system(self)

func _exit_tree():
	Game.unregister_system(self)

func _ready():
	pass

func _input(e):
	if e.is_action_pressed("interact"):
		# TODO validate interaction
		for v in _interaction_candidates.values():
			if not v or not v.is_inside_tree: continue
			if v.has_method("interact"):
				v.interact()
				if v.get("target"):
					interacted.emit(v.get("target"))

func _interacted(node: Node):
	pass

func _set_interaction_candidate(node: Node, on: bool):
	if not on:
		_interaction_candidates.erase(node.name)
	else:
		_interaction_candidates[node.name] = node
