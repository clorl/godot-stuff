@tool
extends Resource
class_name Character

signal data_updated(property: StringName, value: Variant)

enum EquipSlot {
	HELMET,
	ARMOR,
	SHOES,
	RING,
	WEAPON_PRIMARY,
	WEAPON_SECONDARY
}

@export var name: String
@export var portrait: Texture
@export_category("Stats")
@export var health: int
@export var speed: float
@export var abilities: Array[Ability]:
	get: return abilities
@export var equipment: Dictionary[EquipSlot, Item]

var entity

func _data_updated(prop: StringName, value: Variant):
	data_updated.emit(prop, value)

func _set(prop, val):
	_data_updated(prop, val)
	return false

@export var can_move = true
