extends CanvasLayer

@onready
var hover_sfx: AudioStreamPlayer = $hover_fx

@onready
var email_input: LineEdit = $SignUpMenu/VBoxContainer/Email
@onready
var pass_input: LineEdit = $SignUpMenu/VBoxContainer2/pass

@onready
var status: RichTextLabel = $SignUpMenu/AuthStatusLabel

@onready
var register_btn: Button = $SignUpMenu/RegisterButton


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://godot/scenes/authentication_menu.tscn")


func _on_mouse_entered() -> void:
	hover_sfx.play()


func _on_register_button_pressed() -> void:
	register_btn.disabled = true
	var auth_status: String = await Auth.register(email_input.text, pass_input.text)
	status.text = auth_status
	register_btn.disabled = false

	if auth_status == "Success":
		get_tree().change_scene_to_file("res://godot/scenes/game_interface.tscn")
