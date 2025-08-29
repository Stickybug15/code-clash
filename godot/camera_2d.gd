extends Camera2D


@onready var ui: CanvasLayer = $UI


func _ready() -> void:
	#_on_viewport_size_changed()
	#get_viewport().connect("size_changed", _on_viewport_size_changed)
	pass


func _on_viewport_size_changed() -> void:
	var screen_size = get_viewport_rect().size
	ui.anchor_left = -screen_size.x / 2
	ui.anchor_right = screen_size.x / 2
	ui.anchor_top = -screen_size.y / 2
	ui.anchor_bottom = screen_size.y / 2
