class_name EntityPlayer
extends Entity

@export
var code_edit: TextEdit
@export
var input: SimulateInput

@onready
var anim_tree: AnimationTree = $AnimationTree
var anim_tree_fsm: AnimationNodeStateMachinePlayback
@onready
var sprite: AnimatedSprite2D = $Sprite

@export
var stats: EntityStats
@export
var gsc: StateChart

var jump_cmd: Command = ImpulseCommand.new()
var dash_cmd: Command = ImpulseCommand.new()
var fall_cmd: Command = FallCommand.new()
var move_cmd: Command = MoveInputCommand.new()

@onready
var idle_state: AtomicState = $StateChart/ParallelState/Locomotion/Idle
@onready
var walk_state: AtomicState = $StateChart/ParallelState/Locomotion/Walk
@onready
var run_state: AtomicState = $StateChart/ParallelState/Locomotion/Run
@onready
var dash_state: AtomicState = $StateChart/ParallelState/Locomotion/Dash

@onready
var grounded_state: AtomicState = $StateChart/ParallelState/AirBorne/Grounded
@onready
var falling_state: AtomicState = $StateChart/ParallelState/AirBorne/Falling
@onready
var jump_state: AtomicState = $StateChart/ParallelState/AirBorne/Jump


# TODO: probably, just make this a getter and setter?
var _wait: bool = false
func wait() -> void:
	_wait = true
func post() -> void:
	if _wait:
		input.env.poll()
		_wait = false


func _ready() -> void:
	anim_tree.active = true
	anim_tree_fsm = anim_tree["parameters/playback"]
	#Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	pass


func _physics_process(delta: float) -> void:
	move_and_slide()


# === Idle State ===
func _on_idle_state_entered() -> void:
	anim_tree_fsm.travel(&"idle")

	velocity = Vector2.ZERO


func _on_idle_state_physics_processing(delta: float) -> void:
	if signf(Input.get_axis("left", "right")) != 0.0:
		gsc.send_event("to_walking")


func _on_idle_state_exited() -> void:
	pass


# === Walking State ===
func _on_walk_state_entered() -> void:
	anim_tree_fsm.travel(&"walk")

	move_cmd.initialize(self, {
		"speed": stats.speed,
	})

	sprite.flip_h = Input.get_axis("left", "right") < 0

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


func _on_walk_state_exited() -> void:
	pass


#  === Running State === TODO: Duplicate of Walking State, but with different speed.
func _on_run_state_entered() -> void:
	anim_tree_fsm.travel(&"run")
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


func _on_run_state_exited() -> void:
	pass


# === Grounded State ===
func _on_grounded_state_physics_processing(delta: float) -> void:
	if Input.is_action_pressed("jump"):
		gsc.send_event("to_jump")

	if not is_on_floor():
		gsc.send_event("to_falling")


# === Jumping State ===
func _on_jump_state_entered() -> void:
	anim_tree_fsm.travel(&"jump")
	anim_tree.get_animation(&"jump").length = stats.jump_time_to_peak
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
	anim_tree_fsm.travel(&"fall")
	anim_tree.get_animation(&"fall").length = stats.jump_time_to_descent
	fall_cmd.initialize(self, {
		"height": stats.jump_height,
		"time_to_descent": stats.jump_time_to_descent,
	})


func _on_falling_state_physics_processing(delta: float) -> void:
	fall_cmd.execute(self, delta)

	if fall_cmd.is_completed(self):
		post()
		gsc.send_event("to_grounded")


# === Dashing State ===
func _on_dash_state_entered() -> void:
	anim_tree_fsm.travel(&"dash")
	anim_tree["parameters/dash/TimeScale/scale"] = stats.dash_duration

	dash_cmd.initialize(self, {
		"magnitude": stats.dash_distance,
		"time_to_peak": stats.dash_duration,
		"direction": Vector2(Input.get_axis("left", "right"),  0),
		"preserve_velocity": true,
	})

	sprite.flip_h = Input.get_axis("left", "right") < 0

	await dash_cmd.actived
	gsc.set_expression_property(&"is_dash_applied", true)
	await dash_cmd.completed
	gsc.set_expression_property(&"is_dash_applied", false)


func _on_dash_state_physics_processing(delta: float) -> void:
	dash_cmd.execute(self, delta)

	var dir: float = signf(Input.get_axis("left", "right"))
	if dir != 0.0 and signf(velocity.x) != dir:
		dash_cmd.complete(self)

	if dash_cmd.is_completed(self):
		post()
		if dir != 0.0:
			gsc.send_event("to_walking")
		else:
			gsc.send_event("to_idle")


func _on_dash_state_exited() -> void:
	anim_tree["parameters/dash/TimeScale/scale"] = 1.0
