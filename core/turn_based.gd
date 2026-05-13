## Manages the given entities and their turns
extends Node
class_name TurnBased

static var timer: Timer

@export var turn_duration := 5.0 ## How long does a turn last when not in turn-based mode

var entities: Array[Entity3D]

func _init(entities: Array[Entity3D]):
	pass
