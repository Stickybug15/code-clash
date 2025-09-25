class_name NativeInput
extends CustomInput


func is_action_pressed(action: StringName) -> bool:
	return Input.is_action_pressed(action)


func get_axis(negative_action: StringName, positive_action: StringName) -> float:
	return Input.get_axis(negative_action, positive_action)
