extends Control

@onready
var name_input: LineEdit = $ProfileCustomization/VBoxContainer/NameInput
@onready
var avatars: HBoxContainer = $ProfileCustomization/VBoxContainer/Images
@onready
var status_label: RichTextLabel = $ProfileCustomization/VBoxContainer/StatusLabel

@onready
var first_avatar: TextureButton = $ProfileCustomization/VBoxContainer/Images/Avatar_1
@onready
var avatar: ButtonGroup = first_avatar.button_group

@onready
var save_btn: Button = $ProfileCustomization/VBoxContainer/Buttons/Save

@export
var main_menu: Control


func _on_visibility_changed() -> void:
	if is_node_ready() and visible:
		status_label.text = ""
		name_input.text = Auth.username
		var avatar_btn: TextureButton = avatars.get_node(Auth.avatar_name)
		avatar_btn.button_pressed = true


func _on_save_pressed() -> void:
	save_btn.disabled = true
	var status := await Auth.set_profile(name_input.text, avatar.get_pressed_button().name)
	if status == "Success":
		main_menu.visible = true
	else:
		status_label.text = status
	save_btn.disabled = false
