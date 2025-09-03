class_name EntityAction
extends Node2D


var action_info: Dictionary = {}
var _running: bool = false


func _execute(actor: Entity, data: Dictionary) -> void:
	pass

func _end(actor: Entity) -> void:
	pass


func execute(actor: Entity, data: Dictionary) -> void:
	if _running:
		push_warning(name + " is already active.")
		return
	actor.action = func():
		_running = true
		_execute(actor, data)


func end(actor: Entity) -> void:
	if not _running:
		push_warning(name + " is already inactive.")
		return
	_running = false
	_end(actor)
	actor.wait_semaphore.post()


func is_active(actor: Entity) -> bool:
	return false


func is_running(actor: Entity) -> bool:
	return _running


func update(actor: Entity, delta: float) -> void:
	pass
