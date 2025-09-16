extends TextureButton


func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://godot/scenes/game_interface.tscn")


func _on_mouse_entered() -> void:
	$hover_fx.play()
