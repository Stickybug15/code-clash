extends State


@export
var jump_cmd: JumpCommand
@export
var move_cmd: MoveCommand
@export
var arc_move_cmd: ArcMoveCommand
@export
var stats: EntityStats
@export
var fall_state: State

var upward: bool = false


func _setup(actor: EntityPlayer) -> void:
	actor.env.add_new_method(
		"hero", "jump", fall_state, "to_jump", [])


func _enter(actor: EntityPlayer, previous_state: State) -> void:
	if arc_move_cmd and stats:
		arc_move_cmd.initialize(actor, {
			"distance": stats.jump_height,
			"time_to_accelerate": stats.jump_time_to_peak,
			"time_to_decelerate": stats.jump_time_to_descent,
			"direction": Vector2.UP,
		})
		upward = true


func _update(actor: EntityPlayer, delta: float) -> void:
	print(actor.velocity)
	if arc_move_cmd:
		arc_move_cmd.execute(actor, delta)
	if arc_move_cmd.is_finished(actor):
		transition_to("to_idle")

	if stats:
		move_cmd.initialize(actor, {
			"direction": Input.get_axis("left", "right"),
			"duration": stats.move_duration,
			"speed": stats.speed,
		})


func _exit(actor: EntityPlayer) -> void:
	if jump_cmd:
		jump_cmd.complete(actor)
	if arc_move_cmd:
		arc_move_cmd.complete(actor)
