extends Node

@onready var container = $CanvasLayer/Container

var texts = {}

func set_text(key, value):
	texts[key] = str(value)
	_refresh_ui()

func _refresh_ui():
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
