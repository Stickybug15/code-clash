class_name JumpState
extends EntityState


func _setup() -> void:
	if agent is Entity:
		_init_state("Jump", "to_jump")
		add_event_handler("jump", exec)
		var info := {
			"object_name": "hero",
			"method_name": "jump",
			"parameters": [],
			"description": "",
			"dispatch_name": "to_jump",
			"fsm_name": get_root().name,
		}
		agent.add_invoker(info)


func _enter() -> void:
	if agent is Entity:
		if agent.is_on_floor():
			velocity = agent.up_direction * abs(agent.stats.jump_velocity)
		else:
			dispatch("to_air")


func exec(params) -> bool:
	blackboard.populate_from_dict(params)
	return true


func _update(delta: float) -> void:
	if agent is Entity:
		if velocity.y < 0.0:
			velocity.y += agent.stats.jump_gravity * delta
		else:
			velocity = Vector2.ZERO
			dispatch("to_air")
			agent.air_hsm.dispatch("to_fall")
			agent.air_hsm.get_active_state().exited.connect(falling_exit, ConnectFlags.CONNECT_ONE_SHOT)

func falling_exit() -> void:
	agent.wait_semaphore.post()
