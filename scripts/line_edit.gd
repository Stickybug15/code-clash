extends LineEdit


func _on_focus_entered() -> void:
  self.grab_focus()


func _on_focus_exited() -> void:
  self.release_focus()
