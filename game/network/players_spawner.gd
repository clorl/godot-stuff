extends MultiplayerSpawner

func _ready():
	if not multiplayer.is_server(): return
	multiplayer.peer_connected.connect(_on_join)
	multiplayer.peer_disconnected.connect(_on_leave)
	_on_join(1)

func _on_join(id: int):
	var s = load(get_spawnable_scene(0))
	if not s: return
	var p = s.instantiate()
	p.name = "Player_%d" % id
	add_child(p)
	await p.ready
	p.controller.set_multiplayer_authority(id)

func _on_leave(id: int):
	if not multiplayer.is_server(): return
	var p = get_node_or_null("Player_%d" % id)
	if p:
		p.queue_free()
