extends LimboState


func _setup() -> void:
	print(name, " _setup: ", get_root().name)
	get_root().add_transition(get_root().ANYSTATE, get_root().get_node(^"Jump"), "to_jump")


func _enter() -> void:
	print(name, " _enter")
	agent.velocity.y = agent.JUMP_VELOCITY
	dispatch("to_fall")
