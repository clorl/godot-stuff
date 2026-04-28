extends Area3D

var controlling_player := 1

func _command(cmd: Command):
	pass

var selected := false:
	set(v):
		$SelectOutline.visible = v
		selected = v
		
class CmdMove extends Command:
	var target_position: Vector3

	func execute():
		pass
	func unexecute():
		pass
