class_name Swordman
extends CharacterBody2D

@export var stats: EntityStats
@export var code_edit: TextEdit
@export var wren_env: WrenEnvironment


func _physics_process(delta: float) -> void:
	move_and_slide()


func _on_jump_btn_pressed() -> void:
	pass


func _on_move_left_btn_pressed() -> void:
	pass


func _on_move_right_btn_pressed() -> void:
	pass

var thread: Thread = Thread.new();
func _on_run_pressed() -> void:
	if thread.is_alive():
		push_error("Interpreter is already running!")
		return
	thread.start(Callable(self, "run_interpreter_async"), Thread.PRIORITY_NORMAL)

func run_interpreter_async():
	wren_env.run_interpreter(code_edit.text)
	thread = Thread.new()
