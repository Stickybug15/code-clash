class_name CustomInput
extends Node


func is_action_pressed(action: StringName) -> bool:
	push_error(name, ".is_action_pressed() is not implemented!")
	return false


func get_axis(negative_action: StringName, positive_action: StringName) -> float:
	push_error(name, ".get_axis() is not implemented!")
	return 0.0


func try_wait() -> void:
	push_warning(name, ".try_wait() not implemented.")


func try_post() -> void:
	push_warning(name, ".try_post() not implemented.")


func post() -> void:
	push_warning(name, ".post() not implemented.")


func can_post() -> bool:
	push_warning(name, ".can_post() not implemented.")
	return true


func is_ready() -> bool:
	push_warning(name, ".is_ready() not implemented.")
	return true


func is_running() -> bool:
	push_warning(name, ".is_running() not implemented.")
	return true


func run() -> void:
	push_warning(name, ".run() not implemented.")
