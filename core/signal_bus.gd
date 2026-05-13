extends Node

signal entity_data_changed(new_data: Resource, e: Entity3D)
signal entity_interacted(e: Entity3D)
signal position_interacted(info: Dictionary)

signal party_updated(new: Array[Character])
signal character_selection_updated(new: Array[Character])
