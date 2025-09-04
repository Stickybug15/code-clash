class_name GroundState
extends EntityState


func _setup() -> void:
	print(name, " _setup: ", get_root().name)
	get_root().add_transition(get_root().ANYSTATE, get_root().get_node(^"Ground"), "to_ground")


func _enter() -> void:
	print(name, " _enter")
	agent.ground_hsm.dispatch("to_idle")
