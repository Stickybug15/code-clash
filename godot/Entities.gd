extends Node


func is_ready() -> bool:
	return get_children().all(
		func(c):
			if c is Entt:
				return c.is_pending()
			return false)


func execute() -> void:
	if not is_ready():
		return
	for c in get_children():
		if c is Entt:
			c.execute()
