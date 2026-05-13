@tool
extends ShapeCast3D
class_name SnapToGround

@export_tool_button("Snap to Ground", "") var _snap_button = _snap_button_func

@export var use_project_settings := true:
	set(v):
		use_project_settings = v
		if v:
			collision_mask = ProjectSettings.get_setting(G.SETTING_GROUND_PHYSICS_LAYER)
			
@export var target: Node3D
@export var update_in_editor := false
@export var up_tolerance := .98 ## When colliding with a surface, how much its normal can deviate from UP. If it deviates to much we'll not snap there (1 means perfect match, 0 means anything that doesn't point down)
@export var min_distance := .02 ## If the current distance to the ground is under this, we don't snap

func _enter_tree():
	if use_project_settings:
		collision_mask = ProjectSettings.get_setting(G.SETTING_GROUND_PHYSICS_LAYER)
	if not target:
		target = get_parent()

func _ready():
	assert(target)
	assert(shape)

func _physics_process(_dt):
	if Engine.is_editor_hint() and not update_in_editor: return
	snap()

func snap() -> bool:
	if not is_colliding():
		return false

	var y = -INF
	for i in range(get_collision_count()):
		if get_collision_normal(i).dot(Vector3.UP) < up_tolerance: continue
		y = max(get_collision_point(i).y, y)

	if abs(target.global_position.y - y) >= min_distance:
		target.global_position.y = y
		return true
	return false

func _snap_button_func():
	if not snap():
		print("Nope")
