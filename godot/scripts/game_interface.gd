extends Control


func _on_quit_button_pressed() -> void:
	get_tree().quit()



func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://godot/scenes/player_name.tscn")



func _on_play_button_mouse_entered() -> void:
	$"TouchScreenButton/VBoxContainer/hover fx".play()

func _on_custom_button_mouse_entered() -> void:
	$"TouchScreenButton/VBoxContainer/hover fx".play()


func _on_progress_button_mouse_entered() -> void:
	$"TouchScreenButton/VBoxContainer/hover fx".play()


func _on_lead_b_button_mouse_entered() -> void:
	$"TouchScreenButton/VBoxContainer/hover fx".play()


func _on_marketplace_button_mouse_entered() -> void:
	$"TouchScreenButton/VBoxContainer/hover fx".play()


func _on_quit_button_mouse_entered() -> void:
	$"TouchScreenButton/VBoxContainer/hover fx".play()
