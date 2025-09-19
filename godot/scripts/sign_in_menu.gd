extends CanvasLayer

@onready
var hover_sfx: AudioStreamPlayer = $hover_fx


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://godot/scenes/authentication_menu.tscn")


func _on_mouse_entered() -> void:
	hover_sfx.play()
