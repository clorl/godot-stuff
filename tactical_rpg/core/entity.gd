extends Node
class_name Entity

func _ready():
	pass

# Get entity associated with this node
static func of(node: Node) -> Entity:
	if node.has_meta("entity"):
		var e = node.get_meta("entity")
		if e and e.is_inside_tree():
			return e
		else:
			node.set_meta("entity", null)
			
	var p = node.get_parent()
	if p and p is Entity:
		node.set_meta("entity", p)
		return p
	return null
