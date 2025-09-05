class_name MoveState
extends EntityState


var remaining: float = 0


func _setup() -> void:
	if agent is Entity:
		_init_state("Move", "to_move")
		add_event_handler("move_left", func(params: Dictionary) -> bool:
			blackboard.populate_from_dict(params)
			blackboard.set_var("invoker_name", "move_left")
			return true
		)
		add_event_handler("move_right", func(params: Dictionary) -> bool:
			blackboard.populate_from_dict(params)
			blackboard.set_var("invoker_name", "move_right")
			return true
		)

		var info := {
			"object_name": "hero",
			#"method_name": "", # see below.
			"parameters": [
				{
					"type": type_string(TYPE_INT),
					"name": "steps",
					"description": "",
					"default": 1,
				}
			],
			"description": "",
			"dispatch_name": "to_move",
			"fsm_name": get_root().name,
		}
		agent.add_invoker(info.merged({"method_name": "move_left"}, true))
		agent.add_invoker(info.merged({"method_name": "move_right"}, true))


func _enter() -> void:
	if agent is Entity:
		var invoker_name = blackboard.get_var("invoker_name", "no invoker", true)
		var distance: int = agent.stats.distance * int(blackboard.get_var("steps", 0, true))
		match invoker_name:
			"move_left":
				remaining = distance * -1
			"move_right":
				remaining = distance * 1
			_:
				printerr("Invalid '" + invoker_name + "' name.")


func _update(delta: float) -> void:
	if agent is Entity:
		var step: float = sign(remaining) * agent.stats.speed

		# TODO: rewrite this, the last iteratation for 'remaining' isn't used.
		if abs(step) * delta >= abs(remaining):
			velocity.x = 0
			remaining = 0
			dispatch("to_idle")
		else:
			velocity.x = step
			remaining -= step * delta


func _exit() -> void:
	if agent is Entity:
		agent.wait_semaphore.post()
