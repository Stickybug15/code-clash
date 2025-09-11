class_name Entities
extends Node


func is_ready() -> bool:
	return get_children().all(
		func(c):
			if c is Entity:
				return c.is_pending()
			return false)


func execute() -> void:
	if not is_ready():
		return
	for c in get_children():
		if c is Entity:
			c.execute()
