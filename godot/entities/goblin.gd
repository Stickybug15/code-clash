class_name Goblin
extends Entity


func _ready() -> void:
	_init_hsm()


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("jump") and is_on_floor():
		print(air_hsm.dispatch("jump"))


	if Input.is_action_pressed("left"):
		air_hsm.dispatch("move_left", {"steps": 1})
	elif Input.is_action_pressed("right"):
		air_hsm.dispatch("move_right", {"steps": 1})

	velocity = get_total_velocity()
	move_and_slide()
