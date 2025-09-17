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
var stats: EntityStats
@export
var gsc: StateChart

var jump_cmd: ImpulseCommand = ImpulseCommand.new()
var dash_cmd: ImpulseCommand = ImpulseCommand.new()
var fall_cmd: FallCommand = FallCommand.new()
var move_cmd: MoveInputCommand = MoveInputCommand.new()

# TODO: probably, just make this a getter and setter?
var _wait: bool = false
func wait() -> void:
	_wait = true
func post() -> void:
	if _wait:
		input.env.poll()
		_wait = false


func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	pass


func _physics_process(delta: float) -> void:
	input.debug()
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
	wait()

func _on_walk_state_physics_processing(delta: float) -> void:
	move_cmd.execute(self, delta)

	if move_cmd.is_completed(self):
		post()
		gsc.send_event("to_idle")
		return
	if Input.is_action_pressed("run"):
		gsc.send_event("to_running")
		return
	if Input.is_action_pressed("dash"):
		gsc.send_event("to_dash")
		return

#  === Running State === TODO: Duplicate of Walking State, but with different speed.
func _on_run_state_entered() -> void:
	animation.play("run")
	move_cmd.initialize(self, {
		"speed": stats.running_speed,
	})
	wait()

func _on_run_state_physics_processing(delta: float) -> void:
	if not Input.is_action_pressed("run"):
		gsc.send_event("to_walking")
		return
	if Input.is_action_pressed("dash"):
		gsc.send_event("to_dash")
		return

	move_cmd.execute(self, delta)

	if move_cmd.is_completed(self):
		post()
		gsc.send_event("to_idle")

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
		"magnitude": stats.jump_height,
		"time_to_peak": stats.jump_time_to_peak,
		"direction": Vector2.UP,
	})
	wait()

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
		post()
		gsc.send_event("to_grounded")


func _on_dash_state_entered() -> void:
	animation.play("dash")
	animation.speed_scale = stats.dash_duration
	dash_cmd.initialize(self, {
		"magnitude": stats.dash_distance,
		"time_to_peak": stats.dash_duration,
		"direction": Vector2(Input.get_axis("left", "right"),  0),
	})


func _on_dash_state_physics_processing(delta: float) -> void:
	dash_cmd.execute(self, delta)

	if dash_cmd.is_completed(self):
		post()
		if signf(Input.get_axis("left", "right")) != 0.0:
			gsc.send_event("to_idle")
		else:
			gsc.send_event("to_walking")


func _on_dash_state_exited() -> void:
	animation.speed_scale = 1.0
