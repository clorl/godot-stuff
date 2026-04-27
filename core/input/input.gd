# Component that exposes player inputs
extends Node

@export var map: InputMapResource

func _ready():
	if not map:
		push_warning("No input map for node %s" % name)
