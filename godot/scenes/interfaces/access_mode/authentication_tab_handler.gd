extends TabContainer

@onready
var auth_methods: Control = $AuthenticationMethods
@onready
var form: Control = $Form

@onready
var sign_in_form: Control = $Form/FormTabContainer/SignInForm
@onready
var sign_up_form: Control = $Form/FormTabContainer/SignUpForm

@onready
var login_btn: Button = $AuthenticationMethods/VBoxContainer/HBoxContainer/Login
@onready
var register_btn: Button = $AuthenticationMethods/VBoxContainer/HBoxContainer/Register
@onready
var anon_btn: Button = $AuthenticationMethods/VBoxContainer/HBoxContainer/Anon
@onready
var auth_method_buttons: Array[Button] = [
	login_btn,
	register_btn,
	anon_btn,
]

@onready
var profile_customization: Control = $ProfileCustomization


func _on_back_button_menu_pressed():
	auth_methods.visible = true


func _on_login_pressed() -> void:
	sign_in_form.visible = true
	form.visible = true


func _on_register_pressed() -> void:
	sign_up_form.visible = true
	form.visible = true


func _on_anon_pressed() -> void:
	for btn in auth_method_buttons:
		btn.disabled = true
	var auth_status: String = await Auth.login_anon()
	for btn in auth_method_buttons:
		btn.disabled = false

	if auth_status == "Success":
		get_tree().change_scene_to_file("uid://bk7f11a367b30")


func _on_sign_up_form_sign_up_completed() -> void:
	profile_customization.visible = true


func _on_sign_in_form_sign_in_complete() -> void:
	get_tree().change_scene_to_file("uid://bk7f11a367b30")
