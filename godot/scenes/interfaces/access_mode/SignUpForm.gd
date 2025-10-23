extends VBoxContainer

@onready var login_btn: Button = $SignUpButton
@onready var email_input: LineEdit = $Email/EmailEdit
@onready var pass_input: LineEdit = $Password/PasswordEdit/LineEdit
@export var status: RichTextLabel


func _on_sign_up_button_pressed() -> void:
	login_btn.disabled = true
	var auth_status: String = await Auth.register(email_input.text, pass_input.text)
	if status:
		status.text = auth_status
	login_btn.disabled = false

	if auth_status == "Success":
		get_tree().change_scene_to_file("uid://bk7f11a367b30")
