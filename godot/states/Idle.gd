extends State


@export
var stats: EntityStats


func _enter(actor: EntityPlayer, previous_state: State) -> void:
	print(name, " _enter")


func _update(actor: EntityPlayer, delta: float) -> void:
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		transition_to("to_walk")
	if Input.is_action_pressed("jump"):
		transition_to("to_jump")

	if not actor.is_on_floor():
		transition_to("to_fall")
