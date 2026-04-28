extends Node
class_name EntitySystem

const DEFAULT_PATH = "Entities"

func _ready():
	_refresh_registry()

@export var root_path: NodePath
var root: Node:
	set(v):
		if is_instance_valid(root):
			if root.child_entered_tree.is_connected(_child_entered): root.child_entered_tree.disconnect(_child_entered)
			if root.child_exiting_tree.is_connected(_child_exiting): root.child_exiting_tree.disconnect(_child_exiting)
			if root.child_order_changed.is_connected(_child_reordered): root.child_order_changed.disconnect(_child_reordered)
		root = v
		root.child_entered_tree.connect(_child_entered)
		root.child_exiting_tree.connect(_child_exiting)
		root.child_order_changed.connect(_child_reordered)
	get:
		if is_instance_valid(root):
			return root
		if not root_path:
			root_path = DEFAULT_PATH
		var candidate = get_tree().current_scene.get_node_or_null(root_path)
		if is_instance_valid(candidate):
			self.root = candidate
			return root
		var node = Node.new()
		node.name = DEFAULT_PATH
		get_tree().current_scene.add_child(node)
		node.owner = get_tree().current_scene
		self.root = node
		return root

func register(n: Node):
	if not n.is_in_group("entity"):
		n.add_to_group("entity")

func unregister(n: Node):
	if n.is_in_group("entity"):
		n.remove_from_group("entity")

func query(...child_types: Array) -> Dictionary[String, Node]:
	var res = {}
	
	for entity in root.get_children():
		var found_components = {}
		
		for child in entity.get_children():
			var type_name = Game.get_class_name(child)
			if type_name in child_types:
				found_components[type_name] = child
		
		if found_components.size() == child_types.size():
			res[entity.name] = entity
			
	return res

func _enter_tree():
	Game.register_system(self)

func _exit_tree():
	Game.unregister_system(self)

func _refresh_registry():
	pass

func _child_entered(node: Node):
	if node.get_parent() != root: return
	register(node)

func _child_exiting(node: Node):
	if node.get_parent() != root: return
	unregister(node)

func _child_reordered():
	pass
