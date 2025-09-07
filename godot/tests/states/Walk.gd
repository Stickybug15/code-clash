extends LimboState


@export
var move_cmd: MoveCommand
@export
var stats: EntityStats


func _setup() -> void:
  # TODO: also include 'step'
  agent.add_new_invoker(
    "hero", "walk_left",
    func(param: Dictionary):
      blackboard.set_var("direction", -1)
      dispatch("to_walk"), [])
  agent.add_new_invoker(
    "hero", "walk_right",
    func(param: Dictionary):
      blackboard.set_var("direction", 1)
      dispatch("to_walk"), [])


func _enter() -> void:
  print(name, " _enter")

  if move_cmd and stats:
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
