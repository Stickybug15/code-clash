class_name EntityPlayer
extends Entity

@export
var code_edit: TextEdit
var env: ScriptEnvironment = ScriptEnvironment.new()


func _physics_process(delta: float) -> void:
	move_and_slide()


func _on_run_pressed() -> void:
	env.run_async(code_edit.text)
