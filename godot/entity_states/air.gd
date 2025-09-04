class_name AirState
extends EntityState


func _setup() -> void:
	get_root().add_transition(get_root().ANYSTATE, get_root().get_node(^"Air"), "to_air")
