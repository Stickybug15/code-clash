extends LimboState


var _agent : Swordman


func get_state(path: String) -> LimboState:
	return _agent.hsm.get_node(path)


func _setup():
	_agent = agent
	_agent.hsm.add_transition(self, get_state("Jumping"), &"jump")
	_agent.hsm.add_transition(self, get_state("MoveLeft"), &"move_left")
	_agent.hsm.add_transition(self, get_state("MoveRight"), &"move_right")


func _update(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		dispatch(&"jump")
	if Input.is_action_pressed("left"):
		dispatch(&"move_left")
	if Input.is_action_pressed("right"):
		dispatch(&"move_right")
