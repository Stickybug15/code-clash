class_name EntityPlayer
extends Entity

@export
var code_edit: TextEdit
@export
var input: SimulateInput
@onready
var animation: AnimationPlayer = $Animation
@onready
var sprite: AnimatedSprite2D = $Sprite

@export
var impulse_cmd: ImpulseCommand
@export
var fall_cmd: FallCommand
@export
var move_cmd: MoveInputCommand
@export
var jump_cmd: JumpCommand
@export
var stats: EntityStats
@export
var gsc: StateChart


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED


func _physics_process(delta: float) -> void:
	move_and_slide()

# === Idle State ===
func _on_idle_state_entered() -> void:
	velocity = Vector2.ZERO
	animation.play(&"idle")

func _on_idle_state_physics_processing(delta: float) -> void:
	if signf(Input.get_axis("left", "right")) != 0.0:
		gsc.send_event("to_walking")

# === Walking State ===
func _on_walk_state_entered() -> void:
	animation.play("walk")
	move_cmd.initialize(self, {
		"speed": stats.speed,
	})

func _on_walk_state_input(event: InputEvent) -> void:
	print("_on_walk_state_input")

func _on_walk_state_physics_processing(delta: float) -> void:
	if Input.is_action_pressed("run"):
		gsc.send_event("to_running")
		return

	move_cmd.execute(self, delta)

	if move_cmd.is_completed(self):
		gsc.send_event("to_idle")

func _on_walk_state_exited() -> void:
	input.env.poll()

#  === Running State === TODO: Duplicate of Walking State, but with different speed.
func _on_run_state_entered() -> void:
	animation.play("run")
	move_cmd.initialize(self, {
		"speed": stats.running_speed,
	})

func _on_run_state_physics_processing(delta: float) -> void:
	if not Input.is_action_pressed("run"):
		gsc.send_event("to_walking")
		return

	move_cmd.execute(self, delta)

	if move_cmd.is_completed(self):
		gsc.send_event("to_idle")

func _on_run_state_exited() -> void:
	input.env.poll()

# === Grounded State ===
func _on_grounded_state_entered() -> void:
	gsc.send_event("to_idle")

func _on_grounded_state_physics_processing(delta: float) -> void:
	if Input.is_action_pressed("jump"):
		gsc.send_event("to_jump")

	if not is_on_floor():
		gsc.send_event("to_falling")

# === Jumping State ===
func _on_jump_state_entered() -> void:
	animation.play(&"jump")
	jump_cmd.initialize(self, {
		"height": stats.jump_height,
		"time_to_peak": stats.jump_time_to_peak,
	})

func _on_jump_state_physics_processing(delta: float) -> void:
	jump_cmd.execute(self, delta)

	if jump_cmd.is_completed(self):
		gsc.send_event("to_falling")

# === Falling State ===
func _on_falling_state_entered() -> void:
	animation.play(&"fall")
	fall_cmd.initialize(self, {
		"height": stats.jump_height,
		"time_to_descent": stats.jump_time_to_descent,
	})

func _on_falling_state_physics_processing(delta: float) -> void:
	fall_cmd.execute(self, delta)

	if fall_cmd.is_completed(self):
		gsc.send_event("to_grounded")

func _on_falling_state_exited() -> void:
	input.env.poll()
