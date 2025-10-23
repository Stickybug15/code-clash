extends CanvasLayer


func _on_login_button_pressed() -> void:
	get_tree().change_scene_to_file("uid://dh0d1emcf7ehm")


func _on_register_button_pressed() -> void:
	get_tree().change_scene_to_file("uid://cr14f5om1a0if")


func _on_offline_button_pressed() -> void:
	var status: String = await Auth.start_offline()

	if status == "Success":
		get_tree().change_scene_to_file("uid://bk7f11a367b30")


func _on_anon_button_pressed() -> void:
	var status: String = await Auth.login_anon()

	if status == "Success":
		get_tree().change_scene_to_file("uid://bk7f11a367b30")
