extends Node2D

@onready var ground: StaticBody2D = $Ground
@onready var swordman: Swordman = $Swordman

@onready var camera: Camera2D = $Camera2D

func _ready() -> void:
	_on_viewport_size_changed()
	get_viewport().connect("size_changed", _on_viewport_size_changed)


func _on_viewport_size_changed() -> void:
	var color_rect: ColorRect = ground.get_node("ColorRect")
	var ui: CanvasLayer = camera.get_node("UI")
	var ground_size = color_rect.size
	var half_height = ground_size / 2
	var screen_size = get_viewport_rect().size

	camera.position = Vector2(0, -screen_size.y/2)
