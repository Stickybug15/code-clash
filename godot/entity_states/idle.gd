class_name IdleState
extends EntityState


func _setup() -> void:
	get_root().add_transition(get_root().ANYSTATE, get_root().get_node(^"Idle"), "to_idle")
	get_root().initial_state = self
