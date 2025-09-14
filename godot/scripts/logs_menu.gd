extends Control

var botton_type = null

func _on_login_botton_pressed() -> void:
	get_tree().change_scene_to_file("res://godot/scenes/sign_in_menu.tscn")



func _on_register_botton_pressed() -> void:
	get_tree().change_scene_to_file("res://godot/scenes/sign_up_menu.tscn")


func _on_offline_botton_pressed() -> void:
	get_tree().change_scene_to_file("res://godot/scenes/game_interface.tscn")
