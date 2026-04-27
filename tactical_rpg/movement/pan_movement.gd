extends Node

@export var target: Node3D
@export var max_speed_meters_per_second: float
@export var acceleration_duration_seconds: float

var velocity: Vector3
var target_velocity: Vector3

func _ready():
	if not target:
		target = get_parent()
	assert(target)

func set_target_movement_xz(value: Vector2):
	target_velocity = Vector3(value.x, 0, value.y) * max_speed_meters_per_second

func _process(dt):
	velocity = velocity.move_toward(target_velocity, (max_speed_meters_per_second / acceleration_duration_seconds) * dt)
	target.position += velocity * dt
