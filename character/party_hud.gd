extends Control

@export var character_button_scene: PackedScene
@export var container: Control

func _ready():
	assert(character_button_scene)
	assert(container)
	SignalBus.party_updated.connect(_party_updated)
	SignalBus.character_selection_updated.connect(_char_selection_updated)

func _new_button() -> Control:
	var btn = character_button_scene.instantiate()
	btn.pressed.connect(_button_pressed, CONNECT_APPEND_SOURCE_OBJECT)
	btn.mouse_entered.connect(_button_mouse_enter, CONNECT_APPEND_SOURCE_OBJECT)
	btn.mouse_exited.connect(_button_mouse_exit, CONNECT_APPEND_SOURCE_OBJECT)
	container.add_child(btn)
	return btn

func _party_updated(party):
	for i in range(party.size()):
		var c = party[i]
		var btn: Control
		if i >= container.get_child_count():
			btn = _new_button()
		else:
			btn = container.get_child(i)
		btn.visible = true
		btn.set_meta("character", c)
		btn.icon = c.portrait
	for i in range(party.size(), container.get_child_count()):
		container.get_child(i).visible = false

func _char_selection_updated(sel):
	for btn in container.get_children():
		var chara = btn.get_meta("character")
		if sel.find(chara) < 0:
			btn.modulate = Color.WHITE
		else:
			btn.modulate = Color.ORANGE

func _button_mouse_enter(btn):
	var c = btn.get_meta("character")
	if not c: return
	c.entity.hovered = true

func _button_mouse_exit(btn):
	var c = btn.get_meta("character")
	if not c: return
	c.entity.hovered = false

func _button_pressed(btn):
	var c = btn.get_meta("character")
	if not c: return
	SignalBus.entity_interacted.emit(c.entity)

func _unhandled_input(e):
	if e.is_action_pressed("interact"):
		pass
	pass
