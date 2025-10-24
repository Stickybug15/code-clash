extends Control

@onready
var continue_btn: Button = $ProfileCustomization/VBoxContainer/Buttons/Save

@onready
var name_input: LineEdit = $ProfileCustomization/VBoxContainer/NameInput

@onready
var default_avatar: TextureButton = $ProfileCustomization/VBoxContainer/Images/Avatar_1
@onready
var avatar: ButtonGroup = default_avatar.button_group

@onready
var status_label: RichTextLabel = $ProfileCustomization/VBoxContainer/StatusLabel


func _on_continue_pressed() -> void:
	continue_btn.disabled = true
	var status := await Auth.new_profile(name_input.text, avatar.get_pressed_button().name)
	status_label.text = status

	if status == "Success":
		get_tree().change_scene_to_file("uid://bk7f11a367b30")

	continue_btn.disabled = false
