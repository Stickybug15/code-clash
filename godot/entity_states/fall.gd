class_name FallState
extends EntityState


func _setup() -> void:
	_init_state("Fall", "to_fall")
	get_root().initial_state = self


func _update(delta: float) -> void:
	if agent is Entity:
		if agent.is_on_floor():
			velocity.y = 0
			dispatch("to_ground")
		else:
			velocity.y += agent.stats.fall_gravity * delta
