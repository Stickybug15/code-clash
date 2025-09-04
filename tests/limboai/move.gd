extends LimboState


var initial_position: Vector2
var distance: float = 60
var distance_left: float = 0


func _setup() -> void:
	print(name, " _setup: ", get_root().name)
	get_root().add_transition(get_root().ANYSTATE, get_root().get_node(^"Move"), "to_move")


func _enter() -> void:
	print(name, " _enter")
	distance_left = distance
	initial_position = agent.position


func _update(delta: float) -> void:
	if agent is Entity:
		print(name, " _update")
		print("distance_left = ", distance_left)
		if distance_left > 0:
			var direction := Input.get_axis("left", "right")
			if (direction and distance_left <= 0.0) or direction == 0:
				distance_left = distance
			var distance_delta: float = direction * agent.SPEED * delta
			var new_position = move_toward(agent.position.x, distance_left, distance_delta)
			distance_left -= abs(new_position - agent.position.x)
			agent.position.x = new_position
		else:
			dispatch("to_idle")
