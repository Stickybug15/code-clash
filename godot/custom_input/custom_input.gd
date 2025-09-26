class_name CustomInput
extends Node


func is_action_pressed(action: StringName) -> bool:
	push_error(name, ".is_action_pressed() is not implemented!")
	return false


func get_axis(negative_action: StringName, positive_action: StringName) -> float:
	push_error(name, ".get_axis() is not implemented!")
	return 0.0
