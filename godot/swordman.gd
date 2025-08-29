class_name Swordman
extends CharacterBody2D

@export var unit_speed := 80
@export var unit_distance := 40

var target_position: Vector2

@onready var hsm : LimboHSM = $LimboHSM


func _ready() -> void:
	hsm.initialize(self)
	hsm.set_active(true)


func _on_jump_btn_pressed() -> void:
	hsm.dispatch(&"jump")


func _on_move_left_btn_pressed() -> void:
	hsm.dispatch(&"move_left")


func _on_move_right_btn_pressed() -> void:
	hsm.dispatch(&"move_right")
