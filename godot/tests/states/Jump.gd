extends LimboState


@export
var jump_cmd: JumpCommand
@export
var move_cmd: MoveCommand
@export
var stats: EntityStats
@export
var fall_state: FSM_FallState


func _setup() -> void:
	agent.add_new_invoker(
		"hero", "jump", fall_state, "to_jump",
		[
			{"name": "step", "default_value": 1, "type": type_string(TYPE_INT)},
		])


func _enter() -> void:
	print(name, " _enter")
	if jump_cmd and stats:
		jump_cmd.initialize(agent, {
			"height": stats.jump_height,
			"time_to_peak": stats.jump_time_to_peak,
			"time_to_descent": stats.jump_time_to_descent,
		})


func _update(delta: float) -> void:
	if jump_cmd and stats:
		jump_cmd.execute(agent, delta)

	# TODO: should the jump_cmd be responsible for this?
	if agent.velocity.y > 0.0:
		dispatch("to_fall")

	if stats:
		move_cmd.initialize(agent, {
			"direction": Input.get_axis("left", "right"),
			"duration": stats.move_duration,
			"speed": stats.speed,
		})


func _exit() -> void:
	if jump_cmd:
		jump_cmd.complete(agent)
