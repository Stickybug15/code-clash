extends LimboState


@export
var move_cmd: MoveCommand
@export
var stats: EntityStats
var previous_direction: float = 0.0


func _enter() -> void:
  print(name, " _enter")

  if move_cmd and stats:
    previous_direction = Input.get_axis("left", "right")
    move_cmd.initialize(agent, {
      "direction": previous_direction,
      "duration": stats.move_duration,
      "speed": stats.speed,
    })

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _update(delta: float) -> void:
  print(name, " _update")

  if move_cmd.is_finished(agent):
    dispatch("to_idle")

  if Input.is_action_pressed("jump"):
    dispatch("to_jump")


func _exit() -> void:
  pass
