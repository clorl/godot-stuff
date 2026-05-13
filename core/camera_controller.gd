extends Node3D

@export_custom(PROPERTY_HINT_NONE, "suffix;m/s") var max_speed = 40

var follow_character := false
var focused_characters: Array[Character]

func _ready():

	SignalBus.character_selection_updated.connect(_character_selection_updated)
	pass

func _unhandled_input(e):
	if e.is_action_pressed("camera_toggle_follow_character"):
		follow_character = not follow_character

func _process(dt):
	var input_dir = Input.get_vector("move_left", "move_right", "move_front", "move_back")
	var dir = (transform.basis.x * input_dir.x) + (transform.basis.z * input_dir.y)
	dir.y = 0
	var velocity = dir.normalized() * max_speed

	if follow_character:
		if input_dir.length() == 0:
			_follow()
			return
		else:
			follow_character = false
			
	global_position += velocity * dt

func _character_selection_updated(new: Array[Character]):
	focused_characters = new
	_follow()
	
func _follow():
	if focused_characters.size() == 1:
		var chara = focused_characters[0]
		if is_instance_valid(chara.entity):
			global_position = chara.entity.global_position
