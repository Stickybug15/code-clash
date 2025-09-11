extends State


@export
var fall_cmd: FallCommand
@export
var move_cmd: MoveCommand
@export
var stats: EntityStats


func _enter(actor: EntityPlayer, previous_state: State) -> void:
	fall_cmd.initialize(actor, {
		"height": stats.jump_height,
		"time_to_descent": stats.jump_time_to_descent,
	})


func _update(actor: EntityPlayer, delta: float) -> void:
	if not actor.is_on_floor() and fall_cmd:
		fall_cmd.execute(actor, delta)

	if actor.is_on_floor():
		transition_to("to_idle")

	if stats:
		move_cmd.initialize(actor, {
			"direction": Input.get_axis("left", "right"),
			"duration": stats.move_duration,
			"speed": stats.speed,
		})


func _exit(actor: EntityPlayer) -> void:
	fall_cmd.complete(actor)
