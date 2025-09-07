class_name Swordman
extends EntityWrenPlayer


func _on_run_pressed() -> void:
  wren_env.run_interpreter_async(code_edit.text)
