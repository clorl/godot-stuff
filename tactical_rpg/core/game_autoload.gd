extends Node

var state = {}

""" GAME SYSTEMS """

signal system_registered(name: StringName, ref: GameSystem)
signal system_unregistered(name: StringName, ref: GameSystem)

var systems = {}

func register_system(sys: Node):
	var sys_name = get_class_name(sys).replace("System", "").to_snake_case()
	assert(sys_name)
	var existing = systems.get(sys_name)
	if existing and existing.is_inside_tree: return
	systems[sys_name] = sys
	sys.owner = self
	system_registered.emit(sys_name, sys)

func register_systems(list: Array[Node]):
	for sys in list:
		register_system(sys)

func unregister_system(sys: Node):
	var sys_name = get_class_name(sys).replace("System", "").to_snake_case()
	assert(sys_name)
	var existing = systems.get(sys_name)
	if existing and existing == sys:
		systems.erase(sys_name)
		existing.owner = get_tree().current_scene

func get_class_name(o: Object) -> StringName:
	var s = o.get_script()
	if s and s.get_global_name() != "":
		return s.get_global_name()
	return o.get_class()
