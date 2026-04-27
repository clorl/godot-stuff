extends CharacterBody2D

@export var controller: Node

@export var _server_position: Vector2 = position

# Called on all peers after _ready
func _spawn(opts: Dictionary):
	if not controller:
		controller = get_node("PlayerController")
	assert(controller)
	controller.set_multiplayer_authority(opts.peer_id)

	var curve = opts.data.get("spawn_points")
	if curve is EncodedObjectAsID:
		curve = instance_from_id(curve.object_id)
	assert(curve)
	assert(curve is Curve2D)
	global_position = curve.get_point_position(opts.peer_idx)
	if opts.peer_id == multiplayer.get_unique_id():
		$Camera2D.make_current()

	$Sprite.frame = opts.peer_idx % $Sprite.sprite_frames.get_frame_count("default")

	var rng = RandomNumberGenerator.new()
	rng.seed = opts.peer_id

	var mat = $Sprite.material
	if mat and mat is ShaderMaterial:
		var matcopy = mat.duplicate()
		matcopy.set_shader_parameter("color_1", Vector3( rng.randf(), rng.randf(), rng.randf()))
		matcopy.set_shader_parameter("color_2", Vector3( rng.randf(), rng.randf(), rng.randf()))
		$Sprite.material = matcopy
	if multiplayer.is_server():
		$Timer.timeout.connect(_server_timer)

func _physics_process(_dt):
	if multiplayer.is_server():
		velocity = controller.move.normalized() * 100.0
	else:
		velocity = controller.move.normalized() * randf_range(0.1, 3) * 100.0
	move_and_slide()
	queue_redraw()
	if multiplayer.is_server():
		_server_position = global_position

func _draw():
	draw_line(Vector2(0,0), controller.move * 200.0, Color.GREEN if controller.is_multiplayer_authority() else Color.RED, 5.0)
	draw_circle(to_local(_server_position), 64, Color.GREEN, false, 10)

@rpc("authority", "call_local", "reliable")
func sync_position(new_pos: Vector2):
	if new_pos.distance_squared_to(global_position) >= 100:
		global_position = new_pos

func _server_timer():
	sync_position.rpc(global_position)
	pass
