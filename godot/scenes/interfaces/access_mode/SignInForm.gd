extends VBoxContainer

@onready var login_btn: Button = $LoginButton
@onready var email_input: LineEdit = $Email/EmailEdit
@onready var pass_input: LineEdit = $Password/PasswordEdit/LineEdit
@export var status: RichTextLabel

signal sign_in_complete


func _on_login_button_pressed() -> void:
	login_btn.disabled = true
	var auth_status: String = await Auth.login(email_input.text, pass_input.text)
	status.text = auth_status
	login_btn.disabled = false

	if auth_status == "Success":
		sign_in_complete.emit()
