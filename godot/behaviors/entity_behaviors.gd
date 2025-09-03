class_name EntityBehaviorManager
extends Node

@export var actor: Entity

var behaviors: Dictionary

func _ready() -> void:
	for child in get_children():
		if child is EntityBehavior:
			behaviors[child.name] = child
	enable_behavior("IdleBehavior")
	start_behavior("IdleBehavior")
	enable_behavior("FallBehavior")
	start_behavior("FallBehavior")

func start_behavior(behavior_name: String, data: Dictionary = {}):
	var behavior : EntityBehavior = get_behavior(behavior_name)
	if behavior:
		print("start: ", behavior_name)
		behavior.start(actor, data)

func stop_behavior(behavior_name: String):
	var behavior : EntityBehavior = get_behavior(behavior_name)
	if not behavior or behavior.is_active():
		return
	print("stop: ", behavior_name)
	behavior.stop(actor)

func enable_behavior(behavior_name: String) -> void:
	var behavior : EntityBehavior = get_behavior(behavior_name)
	if not behavior or behavior.is_enabled():
		return
	print("enabled: ", behavior_name)
	behavior.enable()

func disable_behavior(behavior_name: String) -> void:
	var behavior : EntityBehavior = get_behavior(behavior_name)
	if not behavior or not behavior.is_enabled():
		return
	print("disabled: ", behavior_name)
	behavior.disable()


func is_any_behaviors_active(names: Array[String]) -> bool:
	for name in names:
		if get_behavior(name).is_active():
			return true
	return false


func get_behavior(behavior_name: String) -> EntityBehavior:
	var behavior : EntityBehavior = behaviors.get(behavior_name)
	if not behavior:
		push_warning(behavior_name + " not found.")
		return null
	return behavior


func _process(delta: float) -> void:
	var velocity := Vector2.ZERO
	for child: String in behaviors:
		var behavior: EntityBehavior = behaviors[child]
		if not behavior.is_enabled() or not behavior.is_active():
			continue
		behavior.update(actor, delta)
		velocity += behavior.velocity
	actor.velocity = velocity
