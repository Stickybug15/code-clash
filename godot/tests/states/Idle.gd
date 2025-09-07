extends LimboState


@export
var stats: EntityStats


func _enter() -> void:
  print(name, " _enter")


func _update(delta: float) -> void:
  if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
    dispatch("to_walk")
  if Input.is_action_pressed("jump"):
    dispatch("to_jump")

  if not agent.is_on_floor():
    dispatch("to_fall")
