class_name GroundState
extends EntityState


func _setup() -> void:
	_init_state("Ground", "to_ground")

func _enter() -> void:
	agent.ground_hsm.dispatch("to_idle")
