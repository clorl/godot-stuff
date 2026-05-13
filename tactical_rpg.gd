extends Level

@export var character_entity_scene: PackedScene

var spawner: MultiplayerSpawner

var selected_characters: Array[Character]:
	get:
		return Game.party.filter(func(c): return c.entity.selected)

func _enter_tree():
	super._enter_tree()
	if not is_instance_valid(TurnBased.timer):
		TurnBased.timer = Timer.new()

	assert(character_entity_scene)
	spawner = MultiplayerSpawner.new()
	spawner.add_spawnable_scene(character_entity_scene.resource_path)
	spawner.spawn_path = ".."
	spawner.spawn_function = _spawn
	add_child(spawner)

func _ready():
	SignalBus.entity_interacted.connect(_on_entity_interact)
	var spawns = get_tree().get_nodes_in_group("party_spawn")
	var args = CharacterSpawnArgs.new()
	for i in range(Game.party.size()):
		args.character = Game.party[i]
		args.position = spawns[i%spawns.size()].global_position
		args.groups = ["party"]
		spawner.spawn(args)
	SignalBus.party_updated.emit(Game.party)

func _spawn(args: EntitySpawnArgs) -> Node:
	if args is CharacterSpawnArgs:
		var node = character_entity_scene.instantiate()
		node.character = args.character
		node.character.entity = node
		for g in args.groups:
			node.add_to_group(g)
		node.ready.connect(func():
			node.global_position = args.position
		,CONNECT_ONE_SHOT)
		return node
	return Node.new()

func _on_entity_interact(e: Entity3D):
	if e is CharacterEntity:
		if e.is_in_group("party"):
			for c in Game.party:
				if c == e.character: continue
				c.entity.selected = false
			e.selected = true
		SignalBus.character_selection_updated.emit(selected_characters)

func _on_position_interact(info: Dictionary):
	SignalBus.position_interacted.emit(info)

func _unhandled_input(e):
	await get_tree().process_frame
	if get_viewport().is_input_handled(): return
	if e.is_action_pressed("interact"):
		_on_position_interact(view_to_world(e.position))
