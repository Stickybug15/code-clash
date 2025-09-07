class_name KeyboardMovementController
extends Node

@export
var enable: bool = true:
  set(value):
    set_physics_process(value)
    print("value: ", value)
    enable = value
  get:
    return enable

@export
var body: CharacterBody2D
@export
var stats: EntityStats


func _aready() -> void:
  assert(body, "set a CharacterBody2D for " + name)
  assert(stats, "set a EntityStats for " + name)


func _physics_process(delta: float) -> void:
  if not body.is_on_floor():
    if body.velocity.y < 0.0:
      body.velocity.y += abs(stats.jump_gravity) * delta
    else:
      body.velocity.y += abs(stats.fall_gravity) * delta

  if Input.is_action_pressed("jump") and body.is_on_floor():
    body.velocity.y = stats.jump_velocity

  var direction := Input.get_axis("left", "right")
  if direction:
    body.velocity.x = direction * stats.speed
  else:
    body.velocity.x = move_toward(body.velocity.x, 0, stats.speed)
