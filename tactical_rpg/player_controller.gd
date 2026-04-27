extends Node

var selection := []

var _interaction_system: Node:
	get: return Engine.get_singleton("InteractionSystem")

func _spawn(opts: Dictionary):
	set_multiplayer_authority(opts.get("peer_id"))
	if _interaction_system:
		_interaction_system.interacted.connect("_on_interact")

func _on_interact(target: Node3D):
	pass
