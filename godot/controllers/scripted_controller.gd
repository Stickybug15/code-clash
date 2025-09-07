class_name ScriptedController
extends Node


@export
var body: CharacterBody2D
@export
var stats: EntityStats

signal finished

var move_left_var := &"move_left"
var move_right_var := &"move_right"
var jump_var := &"jump"

var _invokes: Dictionary = {}

var _invoke_schemas: Dictionary = {
  "jump": {
    "class_name": "hero",
    "params": []
  },
  "move": {
    "class_name": "hero",
    "params": [
        {"name": "steps", "default_value": 1, "type": type_string(TYPE_INT)},
        {"name": "dir", "default_value": -1, "type": type_string(TYPE_INT)},
    ]
  },
  "move_left": {
    "class_name": "hero",
    "params": [
        {"name": "steps", "default_value": 1, "type": type_string(TYPE_INT)},
        {"name": "dir", "default_value": -1, "type": type_string(TYPE_INT)},
    ]
  },
  "move_right": {
    "class_name": "hero",
    "params": [
      {"name": "steps", "default_value": 1, "type": type_string(TYPE_INT)},
      {"name": "dir", "default_value": 1, "type": type_string(TYPE_INT)},
    ]
  },
}


func _ready() -> void:
  assert(body, "set a CharacterBody2D for " + name)
  assert(stats, "set a EntityStats for " + name)

func _physics_process(delta: float) -> void:
  if not body.is_on_floor():
    if body.velocity.y < 0.0:
        body.velocity.y += abs(stats.jump_gravity) * delta
    else:
        body.velocity.y += abs(stats.fall_gravity) * delta

  if is_invoked(jump_var) and body.is_on_floor():
    body.velocity.y = stats.jump_velocity

  var direction := get_axis(move_left_var, move_right_var)
  if direction:
    body.velocity.x = direction * stats.speed
  else:
    body.velocity.x = move_toward(body.velocity.x, 0, stats.speed)

# helper methods

func jump(active: bool = true) -> void:
  _invokes[jump_var] = active
func move_left(active: bool = true) -> void:
  _invokes[move_left_var] = active
func move_right(active: bool = true) -> void:
  _invokes[move_right_var] = active
func clear() -> void:
  _invokes.clear()


func is_invoked(invoker_name: String) -> bool:
  assert(invoker_name in [jump_var, move_left_var, move_right_var], invoker_name + " is not a valid invoker name.")
  return _invokes.get(invoker_name, false)
func get_axis(left: String, right: String) -> float:
  return float(is_invoked(right)) - float(is_invoked(left))
