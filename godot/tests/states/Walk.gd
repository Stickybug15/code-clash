extends LimboState


@export
var movement_cmd: MoveInputCommand
@export
var stats: EntityStats


func _enter() -> void:
  print(name, " _enter")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _update(delta: float) -> void:
  print(name, " _update")

  var direction: int = Input.get_axis("left", "right")
  if is_zero_approx(direction):
    dispatch("to_idle")
  elif stats:
    movement_cmd.initialize(agent, {
      "direction": direction,
      "speed": stats.speed,
    })
    movement_cmd.execute(agent, delta)

  if Input.is_action_pressed("jump"):
    dispatch("to_jump")


func _exit() -> void:
  movement_cmd.complete(agent)
