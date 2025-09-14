extends Control
@onready var main_buttons: VBoxContainer = $TouchScreenButton/MainButtons
@onready var settings: Panel = $Settings

func _ready():
	main_buttons.visible =true
	settings.visible = false

func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://godot/scenes/player_name.tscn")

func _on_custom_button_pressed() -> void:
	pass # Replace with function body.

func _on_progress_button_pressed() -> void:
	pass # Replace with function body.


func _on_lead_b_button_pressed() -> void:
	pass # Replace with function body.

func _on_marketplace_button_pressed() -> void:
	pass # Replace with function body.

func _on_setting_button_pressed():
	print("Settings button pressed")
	main_buttons.visible = false
	settings.visible = true

func _on_play_button_mouse_entered() -> void:
	$"TouchScreenButton/MainButtons/hover fx".play()

func _on_custom_button_mouse_entered() -> void:
	$"TouchScreenButton/MainButtons/hover fx".play()


func _on_progress_button_mouse_entered() -> void:
	$"TouchScreenButton/MainButtons/hover fx".play()


func _on_lead_b_button_mouse_entered() -> void:
	$"TouchScreenButton/MainButtons/hover fx".play()


func _on_marketplace_button_mouse_entered() -> void:
	$"TouchScreenButton/MainButtons/hover fx".play()


func _on_quit_button_mouse_entered() -> void:
	$"TouchScreenButton/MainButtons/hover fx".play()

func _on_setting_button_mouse_entered() -> void:
	$"TouchScreenButton/MainButtons/hover fx".play()

func _on_return_button_mouse_entered() -> void:
	$"TouchScreenButton/MainButtons/hover fx".play()


func _on_return_button_pressed() -> void:
	_ready()


func _on_music_control_value_changed(value: float) -> void:
	pass # Replace with function body.
