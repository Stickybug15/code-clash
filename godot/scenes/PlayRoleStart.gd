extends Control


func _on_char_1_button_pressed() -> void:
	get_tree().change_scene_to_file("res://godot/Arena.tscn")


func _on_char_2_button_pressed() -> void:
	get_tree().change_scene_to_file("res://godot/Arena.tscn")


func _on_char_3_button_pressed() -> void:
	get_tree().change_scene_to_file("res://godot/Arena.tscn")


func _on_char_1_button_mouse_entered() -> void:
	$TouchScreenButton/hover_fx.play()

func _on_char_2_button_mouse_entered() -> void:
	$TouchScreenButton/hover_fx.play()



func _on_char_3_button_mouse_entered() -> void:
	$TouchScreenButton/hover_fx.play()
