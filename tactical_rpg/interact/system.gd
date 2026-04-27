extends Node

const NAME = "InteractionSystem"

signal interacted(node: CollisionObject3D)

var _interaction_candidates : Dictionary[String, Node] = {}

func _enter_tree():
	if not Engine.has_singleton(NAME):
		Engine.register_singleton(NAME, self)
		owner = get_tree().root
	else:
		push_warning("System called %s already exists, node %s is deleting itself" % [NAME, name])
		queue_free()

func _ready():
	print("%s ready" % NAME)
	#interacted.connect(func(n): print("Interacted %s" % str(n)))

func _input(e):
	if e.is_action_pressed("interact"):
		# TODO validate interaction
		for v in _interaction_candidates.values():
			if not v or not v.is_inside_tree: continue
			if v.has_method("interact"):
				v.interact()
				if v.get("target"):
					interacted.emit(v.get("target"))

func _exit_tree():
	var existing = Engine.get_singleton(NAME)
	if existing and existing == self:
		Engine.unregister_singleton(NAME)

func _interacted(node: Node):
	pass

func _set_interaction_candidate(node: Node, on: bool):
	if not on:
		_interaction_candidates.erase(node.name)
	else:
		_interaction_candidates[node.name] = node
