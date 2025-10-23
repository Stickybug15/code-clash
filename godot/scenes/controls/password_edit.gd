extends HBoxContainer

@onready var line_edit: LineEdit = $LineEdit


func _on_eye_button_toggled(toggled_on: bool) -> void:
	line_edit.secret = not toggled_on
