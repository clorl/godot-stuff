extends Area3D

enum CommandKind {
	MOVE_TO
}

var controlling_player := 1

var selected := false:
	set(v):
		$SelectOutline.visible = v
		selected = v

func _command(kind: int, data: Dictionary):
	pass
