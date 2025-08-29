class_name EntityMovementState
extends LimboState


var _agent : Swordman


func get_state(path: String) -> LimboState:
	return _agent.hsm.get_node(path)


func _setup() -> void:
	_agent = agent
	_agent.hsm.add_transition(self, get_state("Idle"), &"idle")


func _update(delta: float) -> void:
	if _agent.position.distance_to(_agent.target_position) < 1.0:
		_agent.velocity = Vector2.ZERO
		dispatch(&"idle")
	_agent.move_and_slide()


func move(steps: int, direction: Vector2):
	direction = direction.normalized()
	_agent.target_position = _agent.position + _agent.unit_distance * steps * direction
	_agent.velocity = direction * _agent.unit_speed


func move_left(steps: int = 1):
	move(steps, Vector2.LEFT)


func move_right(steps: int = 1):
	move(steps, Vector2.RIGHT)
