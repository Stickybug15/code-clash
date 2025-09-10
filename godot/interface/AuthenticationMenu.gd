#extends HBoxContainer
#
#@onready var email_signin_edit := $SignInMenu/GridContainer/EmailEdit
#@onready var pass_signin_edit := $SignInMenu/GridContainer/PasswordEdit
#
#@onready var email_signup_edit := $SignUpMenu/GridContainer/EmailEdit
#@onready var pass_signup_edit := $SignUpMenu/GridContainer/PasswordEdit
#
#
#func hide_all():
	#for menu in get_children():
		#menu.visible = false
#
#
#func is_valid_email(email: String) -> bool:
	#var email_regex = RegEx.new()
	#email_regex.compile("^[\\w\\-\\.]+@([\\w-]+\\.)+[\\w-]{2,}$")
	#return email_regex.search(email) != null
#
#
#func is_valid_password(password: String) -> bool:
	#return password.length() >= 6
#
#
#func _on_sign_in_btn_pressed() -> void:
	## Validate inputs
	#if email_signin_edit.text.is_empty() or pass_signin_edit.text.is_empty():
		#$SignInMenu/GridContainer/StatusLabel.text = "Please fill in all fields"
		#return
	#
	#if not is_valid_email(email_signin_edit.text):
		#$SignInMenu/GridContainer/StatusLabel.text = "Please enter a valid email address"
		#return
	#
	#if not is_valid_password(pass_signin_edit.text):
		#$SignInMenu/GridContainer/StatusLabel.text = "Password must be at least 6 characters"
		#return
	#
	#Supabase.auth.error.connect(
		#func(error: SupabaseAuthError):
			#$SignInMenu/GridContainer/StatusLabel.text = error.message
	#)
	#Supabase.auth.signed_in.connect(
		#func(user: SupabaseUser):
			#print(user)
			#hide_all()
			#$MainMenu.visible = true
	#)
	#Supabase.auth.sign_in(email_signin_edit.text, pass_signin_edit.text)
#
#
#func _on_sign_up_btn_pressed() -> void:
	## Validate inputs
	#if email_signup_edit.text.is_empty() or pass_signup_edit.text.is_empty():
		#$SignUpMenu/GridContainer/StatusLabel.text = "Please fill in all fields"
		#return
	#
	#if not is_valid_email(email_signup_edit.text):
		#$SignUpMenu/GridContainer/StatusLabel.text = "Please enter a valid email address"
		#return
	#
	#if not is_valid_password(pass_signup_edit.text):
		#$SignUpMenu/GridContainer/StatusLabel.text = "Password must be at least 6 characters"
		#return
	#
	#Supabase.auth.error.connect(
		#func(error: SupabaseAuthError):
			#$SignUpMenu/GridContainer/StatusLabel.text = error.message
	#)
	#Supabase.auth.signed_up.connect(
		#func(user: SupabaseUser):
			#print(user)
			#hide_all()
			#$MainMenu.visible = true
	#)
	#print(email_signup_edit.text, pass_signup_edit.text)
	#Supabase.auth.sign_up(email_signup_edit.text, pass_signup_edit.text)
#
#
#func _on_sign_in_annonymous_pressed() -> void:
	#Supabase.auth.error.connect(
		#func(error: SupabaseAuthError):
			#$AccessModeMenu/StatusLabel.text = error.message
	#)
	#Supabase.auth.signed_in_anonymous.connect(
		#func():
			#hide_all()
			#$MainMenu.visible = true
	#)
	#Supabase.auth.sign_in_anonymous()
#
#
#func _on_sign_out_btn_pressed() -> void:
	#Supabase.auth.error.connect(
		#func(error: SupabaseAuthError):
			#$MainMenu/StatusLabel.text = error.message
	#)
	#Supabase.auth.signed_out.connect(
		#func():
			#hide_all()
			#$AccessModeMenu.visible = true
	#)
	#Supabase.auth.sign_out()
#
#
#func _on_quit_btn_pressed() -> void:
	#get_tree().quit()
#
#
#func _on_back_btn_pressed() -> void:
	#hide_all()
	#$AccessModeMenu.visible = true
#
#
#func _on_goto_sign_in_menu_btn_pressed() -> void:
	#hide_all()
	#$SignInMenu.visible = true
#
#
#func _on_goto_sign_up_menu_btn_pressed() -> void:
	#hide_all()
	#$SignUpMenu.visible = true
#
#
#func _on_sign_up_menu_visibility_changed() -> void:
	#$SignUpMenu/GridContainer/StatusLabel.text = ""
#
#
#func _on_sign_in_menu_visibility_changed() -> void:
	#$SignInMenu/GridContainer/StatusLabel.text = ""
#
#
#func _on_main_menu_visibility_changed() -> void:
	#if $MainMenu.visible:
		#if Supabase.auth.client.is_anonymous:
			#$MainMenu/AuthStatus.text = "Signed In as Anonymous"
		#else:
			#$MainMenu/AuthStatus.text = "Signed In as " + Supabase.auth.client.email
#
#
#func _on_label_visibility_changed() -> void:
	#pass # Replace with function body.




extends HBoxContainer

@onready var email_signin_edit := $SignInMenu/GridContainer/EmailEdit
@onready var pass_signin_edit := $SignInMenu/GridContainer/PasswordEdit
@onready var forgot_pass_btn := $SignInMenu/GridContainer/ForgotPasswordBtn

@onready var email_signup_edit := $SignUpMenu/GridContainer/EmailEdit
@onready var pass_signup_edit := $SignUpMenu/GridContainer/PasswordEdit

@onready var reset_email_edit := $ForgotPasswordMenu/GridContainer/EmailEdit
@onready var reset_status_label := $ForgotPasswordMenu/GridContainer/StatusLabel

@onready var send_reset_btn := $ForgotPasswordMenu/GridContainer/SendResetBtn
@onready var back_from_forgot_btn := $ForgotPasswordMenu/GridContainer/BackBtn

func _ready():
	# Debug: Print all children to see what nodes exist
	print("Available children:")
	for child in get_children():
		print(" - ", child.name)
	
	# Check if ForgotPasswordMenu exists
	if has_node("ForgotPasswordMenu"):
		var forgot_menu = $ForgotPasswordMenu
		print("ForgotPasswordMenu children:")
		for child in forgot_menu.get_children():
			print("   - ", child.name)
			if child is GridContainer:
				print("     GridContainer children:")
				for grandchild in child.get_children():
					print("       - ", grandchild.name, " (", grandchild.get_class(), ")")
	
	# Connect buttons safely
	_connect_buttons()

func _connect_buttons():
	# Connect forgot password button (should exist in SignInMenu)
	if forgot_pass_btn:
		forgot_pass_btn.pressed.connect(_on_forgot_password_btn_pressed)
	else:
		print("ERROR: forgot_pass_btn not found!")
	
	# Connect SendResetBtn safely
	var send_reset_btn = get_node_or_null("ForgotPasswordMenu/GridContainer/SendResetBtn")
	if send_reset_btn:
		send_reset_btn.pressed.connect(_on_send_reset_email_btn_pressed)
		print("SendResetBtn connected successfully")
	else:
		print("ERROR: SendResetBtn not found at path: ForgotPasswordMenu/GridContainer/SendResetBtn")
	
	# Connect BackBtn safely
	var back_from_forgot_btn = get_node_or_null("ForgotPasswordMenu/GridContainer/BackBtn")
	if back_from_forgot_btn:
		back_from_forgot_btn.pressed.connect(_on_back_from_forgot_password_pressed)
		print("BackBtn connected successfully")
	else:
		print("ERROR: BackBtn not found at path: ForgotPasswordMenu/GridContainer/BackBtn")

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

#func _on_send_reset_email_btn_pressed() -> void:
	#var email = reset_email_edit.text
	#
	#if email.is_empty():
		#reset_status_label.text = "Please enter your email address"
		#return
	#
	#if not is_valid_email(email):
		#reset_status_label.text = "Please enter a valid email address"
		#return
	#
	## Connect to Supabase auth events
	#Supabase.auth.error.connect(
		#func(error: SupabaseAuthError):
			#reset_status_label.text = error.message,
		#CONNECT_ONE_SHOT
	#)
	#
	#Supabase.auth.password_recovery_email_sent.connect(
		#func():
			#reset_status_label.text = "Password reset email sent! Check your inbox.",
		#CONNECT_ONE_SHOT
	#)
	#
	## Send password reset email
	#Supabase.auth.reset_password_for_email(email)

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
	
	# Clear any previous connections
	_clear_reset_connections()
	
	# Connect to Supabase auth events
	Supabase.auth.error.connect(_on_reset_error, CONNECT_ONE_SHOT)
	Supabase.auth.password_recovery_email_sent.connect(_on_reset_success, CONNECT_ONE_SHOT)
	
	# Add a timeout check
	await get_tree().create_timer(10.0).timeout
	if reset_status_label.text == "Sending reset email...":
		reset_status_label.text = "Request timed out. Please check your internet connection and try again."
		print("Password reset request timed out")

func _clear_reset_connections():
	# Safely disconnect any existing connections
	if Supabase.auth.error.is_connected(_on_reset_error):
		Supabase.auth.error.disconnect(_on_reset_error)
	if Supabase.auth.password_recovery_email_sent.is_connected(_on_reset_success):
		Supabase.auth.password_recovery_email_sent.disconnect(_on_reset_success)

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

func _on_label_visibility_changed() -> void:
	pass # Replace with function body.


func _on_send_reset_btn_pressed() -> void:
	pass # Replace with function body.


func _on_email_edit_text_change_rejected(rejected_substring: String) -> void:
	pass # Replace with function body.


func _on_email_edit_text_submitted(new_text: String) -> void:
	pass # Replace with function body.


func _on_email_edit_ready() -> void:
	pass # Replace with function body.
