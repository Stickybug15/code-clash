extends TabContainer

@onready
var main_menu: Control = $MainMenu
@onready
var customization_menu: Control = $CustomizationMenu
@onready
var leaderboards_menu: Control = $LeaderboardsMenu
@onready
var settings_menu: Control = $SettingsMenu

@onready
var authentication_menu: Control = $AuthenticationMenu
@onready
var sign_in_form: Control = $AuthenticationMenu/FormTabContainer/SignInForm
@onready
var sign_up_form: Control = $AuthenticationMenu/FormTabContainer/SignUpForm


func _main_menu_visible() -> void:
	main_menu.visible = true


func _on_play_button_pressed() -> void:
	pass # Replace with function body.


func _on_customization_button_pressed() -> void:
	customization_menu.visible = true


func _on_leaderboard_button_pressed() -> void:
	leaderboards_menu.visible = true


func _on_settings_button_pressed() -> void:
	settings_menu.visible = true


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_sign_in_pressed() -> void:
	authentication_menu.visible = true
	sign_in_form.visible = true


func _on_sign_up_pressed() -> void:
	authentication_menu.visible = true
	sign_up_form.visible = true
