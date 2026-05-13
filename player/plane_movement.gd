extends Node3D

var target_direction: Vector3

var velocity: Vector3
@export var max_speed := 100 # meters per second

var current_speed_ratio := 0.0

func _physics_process(delta: float) -> void:
	var forward: Vector3 = transform.basis.z
	var right:	 Vector3 =	transform.basis.x
	forward.y = 0
	right.y	  = 0
	forward = forward.normalized()
	right	= right.normalized()

	velocity = ((right * target_direction.x) + (forward * target_direction.z)).normalized() * max_speed
	global_position += velocity * delta

func set_target_direction_xz(value: Vector2):
	var v = value.normalized()
	target_direction = Vector3(v.x, 0, v.y)
