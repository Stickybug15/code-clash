class_name Component
extends Node

var active := false

func _update(actor, delta: float) -> void:
	pass


func enable() -> void:
	active = true

func disable() -> void:
	active = false


func execute(actor) -> void:
	pass
