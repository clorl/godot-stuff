extends Node

func _ready():
	_update_network_panel()

func _input(e):
	if e.is_action_pressed("debug_overlay"):
		overlay.visible = !overlay.visible
		_update()

func _update():
	_update_network_panel()

#################
# DEBUG OVERLAY #
#################

@onready var overlay = $CanvasLayer/Overlay
@onready var network_text = $CanvasLayer/Overlay/NetworkPanel/VBoxContainer/RichTextLabel

func _update_network_panel(id := 0):
	var t = ["[center]Network Info[/center]"]
	if multiplayer.multiplayer_peer is OfflineMultiplayerPeer:
		t.append("[color=red]Offline[/color]")
		network_text.text = "\n".join(t)
		return
	elif multiplayer.is_server():
		t.append("Server")
	else:
		t.append("Client")

	var peers = multiplayer.get_peers()
	t.append("[hr color=\"#505050\"][center]Peers list[/center]")
	t.append("[color=#57a0ff]%d (Me!)[/color]" % multiplayer.get_unique_id())
	for p in peers:
		t.append(str(p))
	network_text.text = "\n".join(t)

################
# DISPLAY TEXT #
################

@onready var container = $CanvasLayer/TextsContainer

var texts = {}

func set_text(key, value):
	texts[key] = str(value)
	_refresh_texts()

func _refresh_texts():
	if not container: return
	for k in texts.keys():
		var t = texts[k]
		var l = container.get_node_or_null("Label_%s" % k.to_pascal_case())
		if not l:
			l = Label.new()
			l.name = "Label_%s" % k.to_pascal_case()
			container.add_child(l)
		if not t:
			l.visible = false
		else:
			l.visible = true
			l.text = "%s: %s" % [k,t]


func debug_signal(sig: Signal):
	sig.connect(func(): print("Signal %s fired" % sig.get_name()))

func debug_signals(signals: Array[Signal]):
	for s in signals:
		debug_signal(s)
