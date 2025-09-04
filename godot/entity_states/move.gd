class_name MoveState
extends EntityState


var remaining: float = 0


func _setup() -> void:
	print(name, " _setup: ", get_root().name)
	if agent is Entity:
		var info := {
			"object_name": "hero",
			#"method_name": "", # see below.
			"parameters": [
				{
					"type": "int",
					"name": "steps",
					"description": "",
					"default": 1,
				}
			],
			"description": "",
			"dispatch_name": "to_move",
		}
		agent.add_invoker(info.merged({"method_name": "move_left"}, true))
		agent.add_invoker(info.merged({"method_name": "move_right"}, true))
		get_root().add_transition(get_root().ANYSTATE, get_root().get_node(^"Move"), "to_move")


func _enter() -> void:
	print(name, " _enter")


# TODO: `remaining` must be initialized.
func _update(delta: float) -> void:
	if agent is Entity:
		var step: float = sign(remaining) * agent.stats.speed

		if abs(step) * delta >= abs(remaining):
			velocity.x = remaining
			remaining = 0
			dispatch("to_idle")
		else:
			velocity.x = step
			remaining -= step * delta
		agent.add_velocity(velocity)
