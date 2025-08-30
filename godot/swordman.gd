class_name Swordman
extends CharacterBody2D

@export var stats: EntityStats


func _physics_process(delta: float) -> void:
	move_and_slide()


func _on_jump_btn_pressed() -> void:
	pass


func _on_move_left_btn_pressed() -> void:
	pass


func _on_move_right_btn_pressed() -> void:
	pass
