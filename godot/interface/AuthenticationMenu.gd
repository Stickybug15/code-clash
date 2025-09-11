extends HBoxContainer


@onready var email_signin_edit := $SignInMenu/GridContainer/EmailEdit
@onready var pass_signin_edit := $SignInMenu/GridContainer/PasswordEdit
@onready var forgot_pass_btn := $SignInMenu/ForgotPasswordBtn

@onready var email_signup_edit := $SignUpMenu/GridContainer/EmailEdit
@onready var pass_signup_edit := $SignUpMenu/GridContainer/PasswordEdit

@onready var reset_email_edit := $ForgotPasswordMenu/GridContainer/EmailEdit
@onready var reset_status_label := $ForgotPasswordMenu/GridContainer/StatusLabel


func hide_all():
	for menu in get_children():
		menu.visible = false


func is_valid_email(email: String) -> bool:
	var email_regex = RegEx.new()
	email_regex.compile("^[\\w\\-\\.]+@([\\w-]+\\.)+[\\w-]{2,}$")
	return email_regex.search(email) != null


func is_valid_password(password: String) -> bool:
	return password.length() >= 6


func _on_sign_in_btn_pressed() -> void:
	# Validate inputs
	if email_signin_edit.text.is_empty() or pass_signin_edit.text.is_empty():
		$SignInMenu/GridContainer/StatusLabel.text = "Please fill in all fields"
		return

	if not is_valid_email(email_signin_edit.text):
		$SignInMenu/GridContainer/StatusLabel.text = "Please enter a valid email address"
		return

	if not is_valid_password(pass_signin_edit.text):
		$SignInMenu/GridContainer/StatusLabel.text = "Password must be at least 6 characters"
		return

	Supabase.auth.error.connect(
		func(error: SupabaseAuthError):
			$SignInMenu/GridContainer/StatusLabel.text = error.message
	)
	Supabase.auth.signed_in.connect(
		func(user: SupabaseUser):
			print(user)
			hide_all()
			$MainMenu.visible = true
	)
	Supabase.auth.sign_in(email_signin_edit.text, pass_signin_edit.text)


func _on_sign_up_btn_pressed() -> void:
	# Validate inputs
	if email_signup_edit.text.is_empty() or pass_signup_edit.text.is_empty():
		$SignUpMenu/GridContainer/StatusLabel.text = "Please fill in all fields"
		return

	if not is_valid_email(email_signup_edit.text):
		$SignUpMenu/GridContainer/StatusLabel.text = "Please enter a valid email address"
		return

	if not is_valid_password(pass_signup_edit.text):
		$SignUpMenu/GridContainer/StatusLabel.text = "Password must be at least 6 characters"
		return

	Supabase.auth.error.connect(
		func(error: SupabaseAuthError):
			$SignUpMenu/GridContainer/StatusLabel.text = error.message
	)
	Supabase.auth.signed_up.connect(
		func(user: SupabaseUser):
			print(user)
			hide_all()
			$MainMenu.visible = true
	)
	print(email_signup_edit.text, pass_signup_edit.text)
	Supabase.auth.sign_up(email_signup_edit.text, pass_signup_edit.text)


func _on_forgot_password_btn_pressed() -> void:
	hide_all()
	$ForgotPasswordMenu.visible = true


func _on_send_reset_email_btn_pressed() -> void:
	var email = reset_email_edit.text

	if email.is_empty():
		reset_status_label.text = "Please enter your email address"
		return

	if not is_valid_email(email):
		reset_status_label.text = "Please enter a valid email address"
		return

	# Show loading state
	reset_status_label.text = "Sending reset email..."

	# Connect to Supabase auth events
	Supabase.auth.error.connect(_on_reset_error, CONNECT_ONE_SHOT)
	Supabase.auth.password_recovery_email_sent.connect(_on_reset_success, CONNECT_ONE_SHOT)

	# Add a timeout check
	await get_tree().create_timer(10.0).timeout
	if reset_status_label.text == "Sending reset email...":
		reset_status_label.text = "Request timed out. Please check your internet connection and try again."
		print("Password reset request timed out")


func _on_reset_error(error: SupabaseAuthError):
	print("Password reset error: ", error.message)

	# Handle specific error cases
	match error.code:
		"invalid_email":
			reset_status_label.text = "This email is not registered."
		"rate_limit_exceeded":
			reset_status_label.text = "Too many attempts. Please try again later."
		_:
			reset_status_label.text = "Error: " + error.message


func _on_reset_success():
	print("Password reset email sent successfully!")
	reset_status_label.text = "Password reset email sent! Check your inbox."



func _on_back_from_forgot_password_pressed() -> void:
	hide_all()
	$SignInMenu.visible = true


func _on_sign_in_annonymous_pressed() -> void:
	Supabase.auth.error.connect(
		func(error: SupabaseAuthError):
			$AccessModeMenu/StatusLabel.text = error.message
	)
	Supabase.auth.signed_in_anonymous.connect(
		func():
			hide_all()
			$MainMenu.visible = true
	)
	Supabase.auth.sign_in_anonymous()


func _on_sign_out_btn_pressed() -> void:
	Supabase.auth.error.connect(
		func(error: SupabaseAuthError):
			$MainMenu/StatusLabel.text = error.message
	)
	Supabase.auth.signed_out.connect(
		func():
			hide_all()
			$AccessModeMenu.visible = true
	)
	Supabase.auth.sign_out()


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


func _on_sign_up_menu_visibility_changed() -> void:
	$SignUpMenu/GridContainer/StatusLabel.text = ""


func _on_sign_in_menu_visibility_changed() -> void:
	$SignInMenu/GridContainer/StatusLabel.text = ""


func _on_forgot_password_menu_visibility_changed() -> void:
	if $ForgotPasswordMenu.visible:
		reset_status_label.text = ""
		reset_email_edit.text = ""


func _on_main_menu_visibility_changed() -> void:
	if $MainMenu.visible:
		if Supabase.auth.client.is_anonymous:
			$MainMenu/AuthStatus.text = "Signed In as Anonymous"
		else:
			$MainMenu/AuthStatus.text = "Signed In as " + Supabase.auth.client.email
