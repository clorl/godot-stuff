extends Node3D
class_name Entity3D

@export var selected_outline_color: Color
@export var hover_outline_color: Color

@onready var selection_area := $SelectionArea
@onready var visuals_manager := $VisualsManager
@onready var outline := $Outline

var hovered: bool:
	get:
		return selection_area.is_hovered
	set(v):
		selection_area.is_hovered = v
		_update_visuals()

var selected:
	set(v):
		selected = v
		_update_visuals()

func _ready():
	outline.visible = false
	outline.color = hover_outline_color
	selection_area.mouse_entered.connect(_update_visuals)
	selection_area.mouse_exited.connect(_update_visuals)
	add_to_group("entity")

func _update_visuals():
	outline.visible = selected or hovered
	if selected:
		outline.color = selected_outline_color
	elif hovered:
		outline.color = hover_outline_color
