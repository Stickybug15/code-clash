class_name FallState
extends EntityState


func _setup() -> void:
	get_root().add_transition(get_root().ANYSTATE, get_root().get_node(^"Fall"), "to_fall")
	get_root().initial_state = self


func _enter() -> void:
	velocity = Vector2.ZERO


func _update(delta: float) -> void:
	if agent is Entity:
		if agent.is_on_floor():
			dispatch("to_ground")
		else:
			velocity.y += agent.stats.fall_gravity * delta
			agent.add_velocity(velocity)
