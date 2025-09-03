class_name Behavior
extends Node

signal stopped

var _active := false
var _enabled := true

func _update(actor, delta: float) -> void:
	pass


func _enable() -> void:
	_enabled = true

func _disable() -> void:
	_enabled = false


func enable() -> void:
	_enable()

func disable() -> void:
	_disable()


func _start(actor, data: Dictionary) -> void:
	pass

func _stop(actor) -> void:
	pass


func start(actor, data: Dictionary) -> void:
	if not _enabled:
		return
	_active = true
	_start(actor, data)

func stop(actor) -> void:
	if not _enabled:
		return
	stopped.emit()
	_active = false
	_stop(actor)


func update(actor, delta: float) -> void:
	if not _active:
		return
	_update(actor, delta)


func is_active() -> bool:
	return _enabled and _active

func is_enabled() -> bool:
	return _enabled
