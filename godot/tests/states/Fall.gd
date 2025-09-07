extends LimboState


@export
var fall_cmd: FallCommand
@export
var movement_cmd: MoveInputCommand
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

  var direction: int = Input.get_axis("left", "right")
  if not is_zero_approx(direction) and stats:
    movement_cmd.initialize(agent, {
      "direction": direction,
      "speed": stats.speed,
    })
    movement_cmd.execute(agent, delta)


func _exit() -> void:
  movement_cmd.complete(agent)
  fall_cmd.complete(agent)
