class_name IdleComponent
extends Component


@onready var jump : JumpComponent = get_node("../JumpComponent")
@onready var move_left : MoveLeftComponent = get_node("../MoveLeftComponent")
@onready var move_right : MoveRightComponent = get_node("../MoveRightComponent")


func _update(actor: Swordman, delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		jump.execute(actor)
	if Input.is_action_pressed("left"):
		move_left.execute(actor)
	if Input.is_action_pressed("right"):
		move_right.execute(actor)
