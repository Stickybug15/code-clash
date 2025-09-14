class_name Command
extends Node


func initialize(actor, msg: Dictionary = {}) -> void:
	pass


func execute(actor, delta: float):
	pass


func complete(actor) -> void:
	pass


func is_completed(actor) -> bool:
	return false
