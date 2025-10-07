@tool
extends EntityState


#
# FUNCTIONS TO INHERIT IN YOUR STATES
#

# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	super(_args)
	agent.anim_tree_fsm.travel(&"idle")

	agent.velocity = Vector2.ZERO


# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args) -> void:
	pass


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	if agent.input.is_action_pressed(StateNames.walk):
		change_state(&"Walk")
		return
	if signf(agent.input.get_axis("left", "right")) != 0.0:
		if agent.input.is_action_pressed("run"):
			change_state(&"Run")
		elif agent.input.is_action_pressed("dash"):
			change_state(&"Dash")
		else:
			change_state(&"Walk")
		return

	if agent.input.is_action_pressed("attack_1"):
		change_state(&"Attack")
		return


# This function is called each frame after all the update calls
# XSM after_updates the children first, then the root
func _after_update(_delta: float) -> void:
	pass


# This function is called before the State exits
# XSM before_exits the root first, then the children
func _before_exit(_args) -> void:
	pass


# This function is called when the State exits
# XSM exits the children first, then the root
func _on_exit(_args) -> void:
	pass


# when StateAutomaticTimer timeout()
func _state_timeout() -> void:
	pass


# Called when any other Timer times out
func _on_timeout(_name) -> void:
	pass
