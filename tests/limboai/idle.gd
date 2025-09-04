class_name IdleState
extends LimboState


func _setup() -> void:
	print(name, " _setup: ", get_root().name)
	get_root().add_transition(get_root().ANYSTATE, get_root().get_node(^"Idle"), "to_idle")
	get_root().initial_state = self


func _enter() -> void:
	print(name, " _enter")


func _process(delta: float) -> void:
	if agent is Entity:
		if Input.is_action_pressed("jump") and agent.is_on_floor():
			agent.air_hsm.dispatch("to_jump")
			dispatch("to_air")
		if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
			dispatch("to_move")
