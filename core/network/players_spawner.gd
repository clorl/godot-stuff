# Spawns one instance of all scenes under auto spawn scenes for each player that joins.
# It ensure there is one instance of such a node for all registered players and calls a custom _spawn function
# so each instance can set itself
# This does not mean that the player has authority over each instance, it just means the instance has been spawned "for that player"
# the authority is left to the implementation of each scene's _spawn method
extends MultiplayerSpawner

var _player_nodes = {}

@export var spawn_data: Dictionary[String, Variant] # Data to be passed to spawned instances

func _ready():
	spawn_function = _spawn
	if not multiplayer.is_server(): return
	multiplayer.peer_connected.connect(_on_join)
	multiplayer.peer_disconnected.connect(_on_leave)
	_on_join(1)

func _on_join(id: int):
	var _data = _player_nodes.get(id)
	if not _data:
		_player_nodes[id] = { "idx": _player_nodes.keys().size(), "nodes": []}
		_data = _player_nodes.get(id)
	assert(get_spawnable_scene_count())
	for i in range(get_spawnable_scene_count()):
		var inst = spawn({ "peer_id": id, "scene_idx": i, "peer_idx": _data.idx, "data": spawn_data })
		_player_nodes[id].nodes.append(inst)

func _on_leave(id: int):
	pass

# Called on every peer
func _spawn(opts: Dictionary) -> Node:
	assert(opts.scene_idx >= 0 and opts.scene_idx < get_spawnable_scene_count(), "scene_idx out of bounds")
	assert(spawn_path, "spawn_path not set")
	var spawn_node = get_node_or_null(spawn_path)
	assert(spawn_node, "spawn_path is set but can't find the node")

	var scene = load(get_spawnable_scene(opts.scene_idx))
	assert(scene, "spawnable scene with index %d is not defined or empty" % opts.scene_idx)
	var instance = scene.instantiate()
	if instance.has_method("_spawn"):
		instance.ready.connect(func(): instance._spawn(opts), ConnectFlags.CONNECT_ONE_SHOT)
	return instance
