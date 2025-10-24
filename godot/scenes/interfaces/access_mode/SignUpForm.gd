extends VBoxContainer

@onready var login_btn: Button = $SignUpButton
@onready var email_input: LineEdit = $Email/EmailEdit
@onready var pass_input: LineEdit = $Password/PasswordEdit/LineEdit
@export var status: RichTextLabel

signal sign_up_completed


func _on_sign_up_button_pressed() -> void:
	login_btn.disabled = true
	var auth_status: String = await Auth.register(email_input.text, pass_input.text)
	status.text = auth_status
	login_btn.disabled = false

	if auth_status == "Success":
		sign_up_completed.emit()
