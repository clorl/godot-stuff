extends CharacterBody2D

@onready var sprite := $Sprite
@onready var controller := $PlayerController
@onready var cam := $Camera2D

@export var default_speed_pixels_per_seconds := 200
@export var mass := 1.0

var _target_vel := Vector2()

@export var server_position := Vector2()

func _physics_process(dt: float):
	if not $Label.text:
		$Label.text = name
	if not cam.is_current() and (name == "Player_%s" % multiplayer.get_unique_id()):
		cam.make_current()
	var dir = controller.move
	_target_vel = dir * default_speed_pixels_per_seconds
	velocity = velocity.move_toward(_target_vel, 10.0 / mass)
	Debug.set_text("velocity", velocity)
	move_and_slide()
	queue_redraw()
	server_position = global_position

func _draw():
	draw_circle(to_local(server_position), 64, Color.RED, false, 3.0, true)
