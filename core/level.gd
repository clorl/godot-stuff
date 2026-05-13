extends Node3D
class_name Level

@export_flags_3d_physics var ground_layer: int

func _enter_tree():
	Game.level = self

func _exit_tree():
	if Game.level == self:
		Game.level = null

class EntitySpawnArgs extends RefCounted:
	var position := Vector3()
	var groups: PackedStringArray

class CharacterSpawnArgs extends EntitySpawnArgs:
	var character: Character

func view_to_world(pos: Vector2) -> Dictionary:
	var cam = get_viewport().get_camera_3d()
	var space = get_world_3d().direct_space_state
	if not cam or not space: return {}

	var query = PhysicsRayQueryParameters3D.new()
	query.from = cam.project_ray_origin(pos)
	query.to = query.from + cam.project_ray_normal(pos) * 1000.0
	query.collision_mask = ground_layer

	return space.intersect_ray(query)
