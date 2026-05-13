extends Entity3D
class_name CharacterEntity

@export var character: Character

@onready var nav = $NavigationAgent3D
@onready var model = $Model
@onready var anim_tree = $AnimationTree

@export_range(0, 5.0) var acceleration_duration: float = 1.0
@export_custom(PROPERTY_HINT_EXP_EASING, "") var acceleration_easing: float = 1.0
@export_range(0, 5.0) var deceleration_duration: float = 1.0
@export_custom(PROPERTY_HINT_EXP_EASING, "attenuation") var deceleration_easing: float = 1.0

var target_velocity: Vector3
var velocity: Vector3:
	set(v):
		velocity = v
		if nav: nav.velocity = v

var max_speed:
	get:
		if character:
			return character.speed
		return 10.0

var state : State = IdleState.new():
	set(v):
		if not state.can_transition(v):
			return
		state.exit(self)
		state_history.append(state)
		state = v
		state.enter(self)

var state_history: Array[State]

var follow_target: Node3D:
	set(v):
		follow_target = v
		nav = $FollowAgent if is_instance_valid(v) else $NavigationAgent3D

func _ready():
	assert(nav)
	super._ready()
	add_to_group("character")
	state.enter(self)
	nav.max_speed = max_speed
	SignalBus.entity_interacted.connect(_on_entity_interacted)
	SignalBus.position_interacted.connect(_on_position_interacted)

func _on_entity_interacted(e: Entity3D):
	pass

func _on_position_interacted(info):
	if selected:
		state = MovingState.new(info.position)
		await get_tree().create_timer(.5).timeout
		for i in range(Game.party.size()):
			var c = Game.party[i]
			if c == character: continue
			#if not is_instance_valid(c.entity): continue
			var angle = PI + (i * .5)
			var offset = (info.position - global_position).normalized() * 3.0
			offset = offset.rotated(Vector3.UP, angle)
			offset.x += sin(global_position.x * global_position.z * (i+1))
			offset.z += cos(global_position.x * global_position.z * (i+1))
			c.entity.state = MovingState.new(info.position + offset, 5.0)

func _process(dt):
	if state is FollowState:
		state.target_pos = follow_target.global_position
	state.process(self, dt)

	var cur_speed: float = velocity.length()
	var tar_speed: float = target_velocity.length()
	
	if tar_speed > cur_speed:
		var t: float = clamp(cur_speed / tar_speed, 0, 1.)
		var rate = (tar_speed / acceleration_duration) * ease(t, acceleration_easing)
		Debug.set_text("rate", snappedf(rate, .1))
		velocity = velocity.move_toward(target_velocity, acceleration_duration)
	elif tar_speed < cur_speed:
		var t: float = clamp(1.0 - (cur_speed / tar_speed), 0, 1.)
		var rate = (tar_speed / deceleration_duration) * ease(t, deceleration_easing)
		Debug.set_text("rate", snappedf(rate, .1))
		velocity = velocity.move_toward(target_velocity, deceleration_duration)
		
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed

	if selected:
		Debug.set_text("target_speed", snappedf(target_velocity.length(), .1))
		Debug.set_text("speed", snappedf(velocity.length(), .1))

	if model and velocity.length() >= .1:
		model.look_at(global_position + velocity)

	global_position += velocity * dt

func move_to(pos: Vector3, tar_desired_distance := 1.0) -> bool:
	if not nav: return true
	if nav.target_position != pos:
		nav.target_position = pos
		nav.max_speed = max_speed
		nav.target_desired_distance = tar_desired_distance
	if nav.is_navigation_finished():
		target_velocity = Vector3.ZERO
		return true
	var next = nav.get_next_path_position()
	target_velocity = (next - global_position).normalized() * max_speed
	return false

# ---------- STATES 

class State extends RefCounted:
	func process(e: CharacterEntity, dt:float): pass
	func enter(e: CharacterEntity): pass
	func exit(e: CharacterEntity): pass
	func can_transition(st: State) -> bool: return true

class IdleState extends State:
	func enter(e):
		if e.anim_tree:
			e.anim_tree.get("parameters/playback").travel("IdleWalk")
	func _to_string(): return "Idle"


class MovingState extends State:
	func _to_string(): return "Move"
	var target_pos: Vector3
	var target_desired_distance: float
	
	func _init(pos: Vector3, dist := 1.0):
		target_pos = pos
		target_desired_distance = dist

	func enter(e):
		if e.anim_tree:
			e.anim_tree.get("parameters/playback").travel("IdleWalk")
		
	func process(e, dt):
		if e.move_to(target_pos, target_desired_distance):
			e.state = IdleState.new()
			return

	func exit(e):
		if e.anim_tree:
			e.anim_tree.set("parameters/IdleWalk/Blend/blend_amount", -1.0)

class FollowState extends MovingState:
	pass

class PreparingAbility extends State:
	pass

class UsingAbility extends State:
	pass
