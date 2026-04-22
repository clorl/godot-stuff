class_name GameTree extends SceneTree

func _initialize() -> void:
	print("One")
	print_verbose(Ctx.cur)
	print("Two")
	print(Ctx.cur)
	pass

func _finalize() -> void:
	pass
