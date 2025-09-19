extends Control


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://godot/scenes/authentication_menu.tscn")


func _on_register_button_mouse_entered() -> void:
	$BG/TouchScreenButton/hover_fx.play()


func _on_back_button_mouse_entered() -> void:
	$BG/TouchScreenButton/hover_fx.play()
