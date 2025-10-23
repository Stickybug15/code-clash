extends CanvasLayer


func _on_yes_button_pressed() -> void:
	get_tree().change_scene_to_file("uid://dh0d1emcf7ehm")


func _on_no_button_pressed() -> void:
	get_tree().quit()
