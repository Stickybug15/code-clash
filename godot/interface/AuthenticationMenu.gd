extends HBoxContainer

@onready var email_signin_edit := $SignInMenu/GridContainer/EmailEdit
@onready var pass_signin_edit  := $SignInMenu/GridContainer/PasswordEdit

@onready var email_signup_edit := $SignUpMenu/GridContainer/EmailEdit
@onready var pass_signup_edit  := $SignUpMenu/GridContainer/PasswordEdit


func hide_all():
  for menu in get_children():
    menu.visible = false


func _on_sign_in_btn_pressed() -> void:
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


func _on_main_menu_visibility_changed() -> void:
  if $MainMenu.visible:
    if Supabase.auth.client.is_anonymous:
      $MainMenu/AuthStatus.text = "Signed In as Anonymous"
    else:
      $MainMenu/AuthStatus.text = "Signed In as " + Supabase.auth.client.email
