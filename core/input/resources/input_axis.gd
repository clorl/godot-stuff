extends Resource class_name InputAxis

@export var x_positive: InputEventAction
@export var x_negative: InputEventAction

@export var y_positive: InputEventAction
@export var y_negative: InputEventAction

@export var z_positive: InputEventAction
@export var z_negative: InputEventAction

@export var device := 0

func get_axis(axis := Vector3.AXIS_X) -> float:
	var res = 0.0
	match axis:
		Vector3.AXIS_X:
			res = 0.0
		Vector3.AXIS_Y:
			res = 0.0
		Vector3.AXIS_Z:
			res = 0.0
	return res

func get_vector2(plane := Plane.PLANE_XZ) -> Vector2:
	var res = Vector2()
	match axis:
		Plane.PLANE_XY:
			res = Vector2()
		Plane.PLANE_XZ:
			res = Vector2()
		Plane.PLANE_YZ:
			res = Vector2()
	return res

func get_vector3() -> Vector3:
	return Vector3
