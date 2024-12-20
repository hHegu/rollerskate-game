extends State

@onready var player: Player = owner

@export var sprite: Sprite2D
@export var rail_detect_raycast: RayCast2D
@export var anim: AnimationPlayer

@onready var jump_cooldown_timer := Utils.create_timer(self, 0.2)
@onready var grind_buffer_timer := Utils.create_timer(self, 0.5)
@onready var jump_buffer_timer := Utils.create_timer(self, 0.15)
@onready var coyote_timer := Utils.create_timer(self, 0.2)

func state_physics_process(_delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	var is_on_floor := player.is_on_floor()

	if Input.is_action_just_pressed("grind"):
		grind_buffer_timer.start()

	var jumped = handle_jump()

	if is_on_floor:
		handle_ground_movement(direction)
	else:
		handle_air_movement(direction)

	if !grind_buffer_timer.is_stopped() and rail_detect_raycast.is_colliding():
		fsm.change_state("GrindState")
		grind_buffer_timer.stop()

	player.move_and_slide()

	if !jumped and is_on_floor and !player.is_on_floor():
		coyote_timer.start()


func handle_ground_movement(direction: float):

	if direction:
		player.velocity.x = move_toward(player.velocity.x, player.MAX_GROUND_SPEED * direction, player.ACCELERATION)
		anim.play("run")
	else:
		player.apply_friction()
		anim.play("idle")


func handle_air_movement(direction: float):
	anim.play("jump")

	player.apply_gravity()

	if direction:
		player.velocity.x = move_toward(player.velocity.x, player.MAX_AIR_SPEED * direction, player.AIR_ACCELERATION)
	else:
		player.apply_friction()


func handle_jump():
	if Input.is_action_pressed("jump"): jump_buffer_timer.start()

	if !player.is_on_floor() and coyote_timer.is_stopped(): return false

	if !jump_buffer_timer.is_stopped() and jump_cooldown_timer.is_stopped():
		jump_cooldown_timer.start()
		jump_buffer_timer.stop()
		coyote_timer.stop()
		player.velocity.y += player.JUMP_VELOCITY
		return true
