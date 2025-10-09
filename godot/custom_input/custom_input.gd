class_name CustomInput
extends Node


func action_pressed(action: StringName) -> void:
	push_error(name, ".action_pressed() is not implemented!")


func action_release(action: StringName) -> void:
	push_error(name, ".action_release() is not implemented!")


func all_action_release(actions: Array[StringName]) -> void:
	push_error(name, ".all_action_release() is not implemented!")


func is_action_pressed(action: StringName) -> bool:
	push_error(name, ".is_action_pressed() is not implemented!")
	return false


func is_any_action_pressed(actions: Array[StringName]) -> bool:
	push_error(name, ".is_any_action_pressed() is not implemented!")
	return false


func get_axis(negative_action: StringName, positive_action: StringName) -> float:
	push_error(name, ".get_axis() is not implemented!")
	return 0.0
