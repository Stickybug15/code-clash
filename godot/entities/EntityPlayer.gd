class_name EntityPlayer
extends Entity

@export
var code_edit: TextEdit
@export
var run_button: Button
@export
var stats: EntityStats
@export
var gsc: StateChart

@onready
var anim_tree: AnimationTree = $AnimationTree
var anim_tree_fsm: AnimationNodeStateMachinePlayback
@onready
var sprite: AnimatedSprite2D = $Sprite

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

@onready
var _hit_box: HitBox = $Sprite/HitBox
@onready
var _status_label: Label = $Status


var jump_cmd: ImpulseCommand
var dash_cmd: ImpulseCommand
var fall_cmd: FallCommand
var move_cmd: MoveInputCommand

var _mouse_entered := false
@onready
var sync: Syncronizer = Syncronizer.new(self, code_edit, run_button)
var input: SimulateInput:
	get: return sync.input


var _face_direction := Vector2.RIGHT


func _ready() -> void:
	anim_tree.active = true
	anim_tree_fsm = anim_tree["parameters/playback"]
	add_child(sync)

	jump_cmd = ImpulseCommand.new()
	dash_cmd = ImpulseCommand.new()
	fall_cmd = FallCommand.new()
	move_cmd = MoveInputCommand.new(input, sprite)

	input.env.started.connect(func() -> void:
		_status_label.text = "Env is Started")
	input.env.finished.connect(func() -> void:
		_status_label.text = "Env is Finished")


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("left_mouse_button") and _mouse_entered:
		position = get_global_mouse_position()
		return
	move_and_slide()


# === Idle State ===
func _on_idle_state_entered() -> void:
	anim_tree_fsm.travel(&"idle")

	velocity = Vector2.ZERO


func _on_idle_state_physics_processing(delta: float) -> void:
	if input.is_action_pressed(StateNames.walk):
		gsc.send_event(&"to_walking")
		return
	if signf(input.get_axis("left", "right")) != 0.0:
		if input.is_action_pressed("run"):
			gsc.send_event("to_running")
		elif input.is_action_pressed("dash"):
			gsc.send_event("to_dash")
		else:
			gsc.send_event("to_walking")
		return

	if input.is_action_pressed("attack_1"):
		gsc.send_event("to_attack_1")
		return


func _on_idle_state_exited() -> void:
	pass


# === Walking State ===
func _on_walk_state_entered() -> void:
	anim_tree_fsm.travel(StateNames.walk)

	move_cmd.initialize(self, {
		"speed": stats.speed,
		"direction": _face_direction.x
	})

	sprite.scale.x = _face_direction.x
	sync.queue()
	print("entered: Walk State")


func _on_walk_state_physics_processing(delta: float) -> void:
	if input.is_any_action_pressed([StateNames.left, StateNames.right]):
		gsc.send_event(&"to_face_direction")

	move_cmd.execute(self, delta)
	if move_cmd.is_completed(self):
		gsc.send_event("to_idle")
		return


func _on_walk_state_exited() -> void:
	input.action_release(StateNames.walk)
	sync.dequeue()


#  === Running State === TODO: Duplicate of Walking State, but with different speed.
func _on_run_state_entered() -> void:
	anim_tree_fsm.travel(&"run")
	move_cmd.initialize(self, {
		"speed": stats.running_speed,
	})

	sprite.scale.x = -1 if input.get_axis("left", "right") < 0.0 else 1
	sync.queue()


func _on_run_state_physics_processing(delta: float) -> void:
	move_cmd.execute(self, delta)

	if move_cmd.is_completed(self):
		gsc.send_event("to_idle")
		return


func _on_run_state_exited() -> void:
	input.action_release(StateNames.walk)
	sync.dequeue()


# === Grounded State ===
func _on_grounded_state_physics_processing(delta: float) -> void:
	if input.is_action_pressed("jump"):
		gsc.send_event("to_jump")

	if not is_on_floor():
		gsc.send_event("to_falling")


# === Jumping State ===
var _jumping := true

func _on_jump_state_entered() -> void:
	_jumping = true
	anim_tree_fsm.travel(&"jump")
	anim_tree.get_animation(&"jump").length = stats.jump_time_to_peak
	jump_cmd.initialize(self, {
		"magnitude": stats.jump_height,
		"time_to_peak": stats.jump_time_to_peak,
		"direction": Vector2.UP,
	})
	sync.queue()


func _on_jump_state_physics_processing(delta: float) -> void:
	if _jumping:
		jump_cmd.execute(self, delta)

		if jump_cmd.is_completed(self):
			anim_tree_fsm.travel(&"fall")
			anim_tree.get_animation(&"fall").length = stats.jump_time_to_descent
			fall_cmd.initialize(self, {
				"height": stats.jump_height,
				"time_to_descent": stats.jump_time_to_descent,
			})
			_jumping = false
	else:
		fall_cmd.execute(self, delta)

		if fall_cmd.is_completed(self):
			gsc.send_event("to_grounded")


func _on_jump_state_exited() -> void:
	sync.dequeue()


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
		gsc.send_event("to_grounded")


func _on_falling_state_exited() -> void:
	#sync.dequeue()
	pass


# === Dashing State ===
func _on_dash_state_entered() -> void:
	anim_tree_fsm.travel(&"dash")
	anim_tree["parameters/dash/TimeScale/scale"] = stats.dash_duration

	dash_cmd.initialize(self, {
		"magnitude": stats.dash_distance,
		"time_to_peak": stats.dash_duration,
		"direction": Vector2(input.get_axis("left", "right"),  0),
		"preserve_velocity": true,
	})

	sprite.scale.x = -1 if input.get_axis("left", "right") < 0.0 else 1

	dash_cmd.actived.connect(
		gsc.set_expression_property.bind(&"is_dash_applied", true),
		ConnectFlags.CONNECT_ONE_SHOT)
	dash_cmd.completed.connect(
		gsc.set_expression_property.bind(&"is_dash_applied", false),
		ConnectFlags.CONNECT_ONE_SHOT)
	sync.queue()


func _on_dash_state_physics_processing(delta: float) -> void:
	dash_cmd.execute(self, delta)

	var dir: float = signf(input.get_axis("left", "right"))
	#if dir != 0.0 and signf(velocity.x) != dir:
		#dash_cmd.complete(self)
		#print("force complete")

	if dash_cmd.is_completed(self):
		if dir != 0.0:
			gsc.send_event("to_walking")
		else:
			gsc.send_event("to_idle")


func _on_dash_state_exited() -> void:
	anim_tree["parameters/dash/TimeScale/scale"] = 1.0
	sync.dequeue()


func _on_attack_state_entered() -> void:
	anim_tree_fsm.travel(&"attack_1")

	sync.queue()


func _on_attack_state_physics_processing(delta: float) -> void:
	if anim_tree_fsm.get_current_node() == "idle":
		gsc.send_event("to_idle")


func _on_attack_state_exited() -> void:
	sync.dequeue()


func _on_hurt_state_entered() -> void:
	# TODO: delaying sending event to gsc by one frame will fix the issue of immidiately switching to to_idle animation.
	# will be using .start for temporary fix.
	anim_tree_fsm.start(&"hurt")
	sync.queue_reset()
	velocity = Vector2.ZERO


func _on_hurt_state_physics_processing(delta: float) -> void:
	if anim_tree_fsm.get_current_node() == "idle":
		gsc.send_event("to_idle")


func _on_mouse_entered() -> void:
	_mouse_entered = true


func _on_mouse_exited() -> void:
	_mouse_entered = false


func take_damage(damage: float) -> void:
	if idle_state.active or walk_state.active or run_state.active:
		health -= damage
		gsc.send_event("to_hurt")
		gsc.send_event("to_grounded")


func _on_hurt_box_area_entered(area: Area2D) -> void:
	if _hit_box == area:
		return

	if area is HitBox:
		take_damage(area.damage)


func _on_face_direction_state_entered() -> void:
	if input.is_any_action_pressed([StateNames.left, StateNames.right]):
		return
	if input.is_action_pressed(StateNames.left):
		_face_direction = Vector2.LEFT
	elif input.is_action_pressed(StateNames.right):
		_face_direction = Vector2.RIGHT
	input.all_action_release([StateNames.left, StateNames.right])
	gsc.send_event(&"to_face_direction_resume")
	print("entered: History State")
