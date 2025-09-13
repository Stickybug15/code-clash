extends Control


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://godot/scenes/play_role_start.tscn")
