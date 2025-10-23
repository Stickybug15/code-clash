extends Button

@onready var hover_sfx: AudioStreamPlayer = $HoverSFX


func _on_mouse_entered() -> void:
	hover_sfx.play()
