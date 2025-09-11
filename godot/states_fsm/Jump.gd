extends State


@export
var jump_cmd: JumpCommand
@export
var move_cmd: MoveCommand
@export
var stats: EntityStats
@export
var fall_state: State


func _setup(actor: EntityPlayer) -> void:
	actor.add_new_method(
		"hero", "jump", fall_state, "to_jump",
		[
			{"name": "step", "default_value": 1, "type": type_string(TYPE_INT)},
		])


func _enter(actor: EntityPlayer, previous_state: State) -> void:
	print(name, " _enter")
	if jump_cmd and stats:
		jump_cmd.initialize(actor, {
			"height": stats.jump_height,
			"time_to_peak": stats.jump_time_to_peak,
			"time_to_descent": stats.jump_time_to_descent,
		})


func _update(actor: EntityPlayer, delta: float) -> void:
	if jump_cmd and stats:
		jump_cmd.execute(actor, delta)

	# TODO: should the jump_cmd be responsible for this?
	if actor.velocity.y > 0.0:
		finished.emit("to_fall")

	if stats:
		move_cmd.initialize(actor, {
			"direction": Input.get_axis("left", "right"),
			"duration": stats.move_duration,
			"speed": stats.speed,
		})


func _exit(actor: EntityPlayer) -> void:
	if jump_cmd:
		jump_cmd.complete(actor)
