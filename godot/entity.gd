class_name Entity
extends CharacterBody2D

@export var stats: EntityStats
@export var code_edit: TextEdit
@export var component_manager: EntityComponentManager
@export var action_manager: EntityActionManager
@export var wren_env: WrenEnvironment

var action: Callable

var wait_semaphore: Semaphore = Semaphore.new()
var wait_mutex: Mutex = Mutex.new()


func _physics_process(delta: float) -> void:
	move_and_slide()
