extends LimboState


func _setup() -> void:
	print(name, " _setup: ", get_root().name)
	get_root().add_transition(get_root().ANYSTATE, get_root().get_node(^"Fall"), "to_fall")
	get_root().initial_state = self


func _update(delta: float) -> void:
	if not agent.is_on_floor():
		agent.velocity += agent.get_gravity() * delta
	else:
		dispatch("to_ground")
