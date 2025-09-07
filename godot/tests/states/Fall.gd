extends LimboState


@export
var fall_cmd: FallCommand
@export
var move_cmd: MoveCommand
@export
var stats: EntityStats


func _enter() -> void:
  print(name, " _enter")
  fall_cmd.initialize(agent, {
    "height": stats.jump_height,
    "time_to_descent": stats.jump_time_to_descent,
  })


func _update(delta: float) -> void:
  if not agent.is_on_floor() and fall_cmd:
    fall_cmd.execute(agent, delta)

  if agent.is_on_floor():
    if Input.is_action_pressed("jump"):
      dispatch("to_jump")
    else:
      dispatch("to_idle")

  if stats:
    move_cmd.initialize(agent, {
      "direction": Input.get_axis("left", "right"),
      "duration": stats.move_duration,
      "speed": stats.speed,
    })


func _exit() -> void:
  fall_cmd.complete(agent)
