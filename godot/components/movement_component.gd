class_name MovementComponent
extends Component


var target_position: Vector2 = Vector2.ZERO

var actor: Swordman
var tween: Tween


func _update(actor: Swordman, delta: float) -> void:
	pass


func _done_moving():
	if tween:
		tween.kill()
		tween = null


func move(actor: Swordman, steps: int, direction: Vector2) -> void:
	direction = direction.normalized()
	target_position = actor.unit_distance * steps * direction

	if !tween:
		tween = get_tree().create_tween()
		tween.tween_property(actor, ^"position", target_position, 0.5).as_relative()
		tween.tween_callback(_done_moving)


func move_left(actor: Swordman, steps: int = 1) -> void:
	move(actor, steps, Vector2.LEFT)


func move_right(actor: Swordman, steps: int = 1) -> void:
	move(actor, steps, Vector2.RIGHT)
