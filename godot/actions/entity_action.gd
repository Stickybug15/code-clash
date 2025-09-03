class_name EntityAction
extends Node2D


var action_info: Dictionary = {}
var _running: bool = false


func _execute(actor: Swordman, data: Dictionary) -> void:
	pass

func execute(actor: Swordman, data: Dictionary) -> void:
	if _running:
		push_warning(name + " is already active.")
		return
	_running = true
	_execute(actor, data);


func _end(actor: Swordman) -> void:
	pass

func end(actor: Swordman) -> void:
	if not _running:
		push_warning(name + " is already inactive.")
		return
	_running = false
	_end(actor)
	actor.wait_semaphore.post()


func is_active(actor: Swordman) -> bool:
	return false


func is_running(actor: Swordman) -> bool:
	return _running


func update(actor: Swordman, delta: float) -> void:
	pass
