class_name EntityState
extends LimboState


var velocity: Vector2 = Vector2.ZERO


func _init_state(state_name: NodePath, dispatch_name: String) -> void:
	get_root().add_transition(get_root().ANYSTATE, get_root().get_node(state_name), dispatch_name)
