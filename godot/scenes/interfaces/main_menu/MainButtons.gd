extends VBoxContainer

@onready
var customization_btn: Button = $CustomizationButton


func _on_main_menu_visibility_changed() -> void:
	if is_node_ready():
		customization_btn.disabled = Auth.is_anonymous
