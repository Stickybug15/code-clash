extends State


@export
var move_cmd: MoveCommand
@export
var stats: EntityStats


func _setup(actor: EntityPlayer) -> void:
	# TODO: also include 'step'
	actor.env.add_new_method(
		"hero", "walk_left", self, "to_walk", [
			{"name": "step", "default_value": 1, "type": type_string(TYPE_INT)},
		])
	actor.env.add_new_method(
		"hero", "walk_right", self, "to_walk", [
			{"name": "step", "default_value": 1, "type": type_string(TYPE_INT)},
		])


func _enter(actor: EntityPlayer, previous_state: State) -> void:
	if move_cmd and stats:
		var args: Dictionary = ctx.get_var("args")
		var method_name = ctx.get_var("method_name")
		if method_name == "walk_right":
			ctx.set_var("direction", 1.0)
		elif method_name == "walk_left":
			ctx.set_var("direction", -1.0)
		move_cmd.initialize(actor, {
			"direction": ctx.get_var("direction", Input.get_axis("left", "right")),
			"duration": stats.move_duration * args["step"],
			"speed": stats.speed,
		})


func _update(actor: EntityPlayer, delta: float) -> void:
	if move_cmd.is_finished(actor):
		transition_to("to_idle")

	if Input.is_action_pressed("jump"):
		transition_to("to_jump")


func _exit(actor: EntityPlayer) -> void:
	pass
