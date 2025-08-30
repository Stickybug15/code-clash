class_name EntityComponents
extends Node

@onready var actor: Swordman = get_parent()

func _process(delta: float) -> void:
	for child in get_children():
		if child is Component:
			child._update(actor, delta)
