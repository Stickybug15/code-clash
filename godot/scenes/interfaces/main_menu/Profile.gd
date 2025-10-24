extends HBoxContainer

@export
var main_menu: Control

@export
var logout_btn: Button

@onready
var auth_methods: HBoxContainer = $TabContainer/AuthenticationMethodsButtons
@onready
var name_label: Label = $TabContainer/NameLabel

@onready
var avatar_image: TextureRect = $Avatar/Image


func _ready() -> void:
	_on_main_menu_visibility_changed()


func _on_main_menu_visibility_changed() -> void:
	if is_node_ready() and main_menu.visible:
		var is_anonymous: bool = true
		if Auth.user:
			is_anonymous = Auth.user.is_anonymous

		if is_anonymous:
			auth_methods.visible = true
			logout_btn.visible = false
		else:
			name_label.visible = true
			name_label.text = Auth.username
			var image: CompressedTexture2D = load("res://assets/Avatars/Avatars/{0}.png".format([Auth.avatar_name]))
			avatar_image.texture = image
			logout_btn.visible = true
