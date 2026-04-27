# Makes NodeA.property the same as NodeB.property
extends Node
class_name PropertyLink

@export var source  : Node
@export var source_prop  : StringName
@export var target  : Node
@export var target_prop  : StringName

func _process(_delta) -> void:
    _copy()

func _copy() -> void:
    if source and target:
        target.set(target_prop, source.get(source_prop))
