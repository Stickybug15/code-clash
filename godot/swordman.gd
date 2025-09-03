class_name Swordman
extends CharacterBody2D

@export var stats: EntityStats
@export var code_edit: TextEdit
@export var component_manager: EntityComponentManager
@export var action_manager: EntityActionManager
@export var wren_env: WrenEnvironment

var wait_semaphore: Semaphore = Semaphore.new()
var wait_mutex: Mutex = Mutex.new()


func _physics_process(delta: float) -> void:
	move_and_slide()


func _on_jump_btn_pressed() -> void:
	pass


func _on_move_left_btn_pressed() -> void:
	pass


func _on_move_right_btn_pressed() -> void:
	pass


func _on_run_pressed() -> void:
	wren_env.run_interpreter_async(code_edit.text)
