class_name IdleState
extends EntityState


func _setup() -> void:
	_init_state("Idle", "to_idle")
	get_root().initial_state = self
