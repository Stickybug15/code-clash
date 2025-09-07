class_name MoveCommand
extends Command

var direction: float
var duration: float
var elapsed: float = 0.0
var speed: float


func initialize(actor: CharacterBody2D, msg: Dictionary = {}) -> void:
  assert(msg.has("direction") and msg["direction"] is int)
  assert(msg.has("duration") and msg["duration"] is float)
  assert(msg.has("speed") and msg["speed"] is float)

  direction = sign(msg["direction"])
  duration = msg["duration"]
  speed = msg["speed"]
  elapsed = 0.0


func execute(actor: CharacterBody2D, delta: float):
  if is_finished(actor):
    return

  elapsed += delta
  actor.position.x += direction * speed * delta


func complete(actor: CharacterBody2D) -> void:
  elapsed = duration


func is_finished(actor: CharacterBody2D) -> bool:
  return elapsed >= duration
