class_name MoveInputCommand
extends Command


var direction: float = 0
var speed: float = 0


func initialize(actor, msg: Dictionary = {}):
  assert(msg.has("speed") and msg["speed"] is float)
  assert(msg.has("direction") and msg["direction"] is int)

  speed = msg["speed"]
  direction = sign(msg["direction"])


func execute(actor: CharacterBody2D, delta: float):
  if direction:
    actor.velocity.x = direction * speed
  else:
    actor.velocity.x = move_toward(actor.velocity.x, 0, speed)


func complete(actor: CharacterBody2D) -> void:
  actor.velocity.x = 0


# TODO: should we implement this?
func is_complete(actor: CharacterBody2D) -> bool:
  assert(false, name + ".is_complete() not implemented")
  return false
