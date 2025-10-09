@tool
extends State


@export var wall_jump_speed := 320


# FUNCTIONS AVAILABLE TO INHERIT

func _on_enter(_args) -> void:
	target.skin.rotation = - target.wall_dir * PI / 2


func jump():
	target.velocity = Vector2(-target.wall_dir * wall_jump_speed, -wall_jump_speed)
	target.velocity = target.velocity.normalized() * wall_jump_speed
	
	if get_parent().in_air:
		target.skin.rotation = - target.velocity.angle_to(Vector2.UP)


func _on_exit(_args) -> void:
	target.skin.rotation = 0
