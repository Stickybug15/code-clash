class_name FallCommand
extends Command


var fall_gravity: float


func initialize(actor: CharacterBody2D, msg: Dictionary = {}):
  assert(msg.has("height") and msg["height"] is float)
  assert(msg.has("time_to_descent") and msg["time_to_descent"] is float)

  var height: float = msg["height"]
  var time_to_descent: float = msg["time_to_descent"]

  fall_gravity = (2.0 * height) / (time_to_descent * time_to_descent)
  actor.velocity.y = 0


func execute(actor: CharacterBody2D, delta: float):
  if not actor.is_on_floor():
    actor.velocity.y += fall_gravity * delta


func is_complete(actor: CharacterBody2D) -> bool:
  return actor.is_on_floor()
