class_name Entity
extends CharacterBody2D


func is_pending() -> bool:
	push_error(name, ".pending not implemented.")
	return false


func activate() -> void:
	push_error(name, ".activate not implemented.")
