extends Node

const NAME = "CommandSystem"

func _enter_tree():
	if not Engine.has_singleton(NAME):
		Engine.register_singleton(NAME, self)
		owner = get_tree().root
	else:
		push_warning("System called %s already exists, node %s is deleting itself" % [NAME, name])
		queue_free()

func _ready():
	print("%s ready" % NAME)

func _exit_tree():
	var existing = Engine.get_singleton(NAME)
	if existing and existing == self:
		Engine.unregister_singleton(NAME)
