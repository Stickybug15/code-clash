class_name JumpState
extends EntityState


func _setup() -> void:
	if agent is Entity:
		var info := {
			"object_name": "hero",
			"method_name": "jump",
			"parameters": [],
			"description": "",
			"dispatch_name": "to_jump",
			"fsm_name": get_root().name,
		}
		agent.add_invoker(info)
		get_root().add_transition(get_root().ANYSTATE, get_root().get_node(^"Jump"), "to_jump")


func _enter() -> void:
	if agent is Entity:
		if agent.is_on_floor():
			velocity = agent.up_direction * abs(agent.stats.jump_velocity)
		else:
			dispatch("to_air")


func _update(delta: float) -> void:
	if agent is Entity:
		if velocity.y < 0.0:
			velocity.y += agent.stats.jump_gravity * delta
		else:
			velocity = Vector2.ZERO
			dispatch("to_air")
			agent.air_hsm.dispatch("to_fall")
			agent.air_hsm.get_active_state().exited.connect(falling_exit, ConnectFlags.CONNECT_ONE_SHOT)
		agent.add_velocity(velocity)


func falling_exit() -> void:
	agent.wait_semaphore.post()
