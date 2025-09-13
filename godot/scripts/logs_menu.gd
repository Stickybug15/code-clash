extends Control

var botton_type = null 

func _on_login_botton_pressed() -> void:
	get_tree().change_scene_to_file("res://sign_in_menu.tscn")
	


func _on_register_botton_pressed() -> void:
	get_tree().change_scene_to_file("res://sign_up_menu.tscn")


func _on_offline_botton_pressed() -> void:
	get_tree().change_scene_to_file("res://game_interface.tscn")
