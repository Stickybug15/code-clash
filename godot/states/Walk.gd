extends LimboState


@export
var move_cmd: MoveCommand
@export
var stats: EntityStats


func _setup() -> void:
	# TODO: also include 'step'
	agent.add_new_method(
		"hero", "walk_left", self, "to_walk", [])
	agent.add_new_method(
		"hero", "walk_right", self, "to_walk", [])


func _enter() -> void:
	print(name, " _enter")

	if move_cmd and stats:
		var method_name = blackboard.get_var("method_name")
		if method_name == "walk_right":
			blackboard.set_var("direction", 1.0)
		elif method_name == "walk_left":
			blackboard.set_var("direction", -1.0)
		move_cmd.initialize(agent, {
			"direction": blackboard.get_var("direction", Input.get_axis("left", "right")),
			"duration": stats.move_duration,
			"speed": stats.speed,
		})


func _update(delta: float) -> void:
	print(name, " _update")

	if move_cmd.is_finished(agent):
		dispatch("to_idle")

	if Input.is_action_pressed("jump"):
		dispatch("to_jump")


func _exit() -> void:
	pass
