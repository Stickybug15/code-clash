extends HBoxContainer

@onready var email_signin_edit := $SignInMenu/GridContainer/EmailEdit
@onready var pass_signin_edit  := $SignInMenu/GridContainer/PasswordEdit

@onready var email_signup_edit := $SignInMenu/GridContainer/EmailEdit
@onready var pass_signup_edit  := $SignInMenu/GridContainer/PasswordEdit


func hide_all():
	for menu in get_children():
		menu.visible = false


func show_main_menu(name: String):
	hide_all()
	$MainMenu.visible = true
	$MainMenu/Status.text = name


func _on_sign_in_btn_pressed() -> void:
	var auth_task: AuthTask = await Supabase.auth.sign_in(email_signin_edit.text, pass_signin_edit.text).completed
	print(auth_task.user)

	hide_all()
	show_main_menu(auth_task.user.email)


func _on_sign_up_btn_pressed() -> void:
	var auth_task: AuthTask = await Supabase.auth.sign_up(email_signup_edit.text, pass_signup_edit.text).completed
	print(Supabase.auth.client)

	hide_all()
	show_main_menu(auth_task.user.email)


func _on_sign_in_annonymous_pressed() -> void:
	print("Signed In as Anonymous is pressed")
	var auth_task: AuthTask = await Supabase.auth.sign_in_anonymous().completed
	print(auth_task.user)

	hide_all()
	show_main_menu("Anonymous")


func _on_sign_out_btn_pressed() -> void:
	var auth_task: AuthTask = await Supabase.auth.sign_out().completed
	print(auth_task.user)

	hide_all()
	$AccessModeMenu.visible = true


func _on_quit_btn_pressed() -> void:
	get_tree().quit()


func _on_back_btn_pressed() -> void:
	hide_all()
	$AccessModeMenu.visible = true


func _on_goto_sign_in_menu_btn_pressed() -> void:
	hide_all()
	$SignInMenu.visible = true


func _on_goto_sign_up_menu_btn_pressed() -> void:
	hide_all()
	$SignUpMenu.visible = true
