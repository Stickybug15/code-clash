extends CanvasLayer


func _on_online_mode_pressed() -> void:
	get_tree().change_scene_to_file("res://godot/scenes/interfaces/access_mode/sign_in_menu.tscn")




func _on_offline_mode_pressed() -> void:
	get_tree().change_scene_to_file("uid://bk7f11a367b30")
