class_name GroundState
extends EntityState


func _setup() -> void:
	get_root().add_transition(get_root().ANYSTATE, get_root().get_node(^"Ground"), "to_ground")


func _enter() -> void:
	agent.ground_hsm.dispatch("to_idle")
