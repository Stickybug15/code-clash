extends Control

@onready var start_button: Button = $BG/TouchScreenButton/start
@onready var line_edit: LineEdit = $BG/TouchScreenButton/Player_name
@onready var name_label: Label = $BG/TouchScreenButton/name

func _ready():
	start_button.visible = false
	line_edit.text_submitted.connect(_on_line_edit_text_entered)

func _on_line_edit_text_entered(newtext: String) -> void:
	name_label.text = "Player Name: " + newtext
	start_button.visible = true

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://godot/scenes/play_role_start.tscn")


func _on_start_mouse_entered() -> void:
	$BG/TouchScreenButton/hover_fx.play()
