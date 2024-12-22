extends State

@onready var player: Player = owner

@export var sprite: Sprite2D
@export var rail_detect_raycast: RayCast2D
@export var anim: AnimationPlayer
@export var speed_boost_particle_effect: CPUParticles2D

@onready var jump_cooldown_timer := Utils.create_timer(self, 0.2)
@onready var grind_cooldown_timer := Utils.create_timer(self, 0.2)
@onready var jump_buffer_timer := Utils.create_timer(self, 0.15)
@onready var coyote_timer := Utils.create_timer(self, 0.2)
@onready var speed_boost_timer := Utils.create_timer(self, 1.0)

var is_boosting := false

func on_state_enter(_data: Dictionary = {}):
	super(_data)
	grind_cooldown_timer.start()


func state_physics_process(_delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	var is_on_floor := player.is_on_floor()
	if player.is_on_floor():
		is_boosting = !speed_boost_timer.is_stopped()
		speed_boost_particle_effect.emitting = !speed_boost_timer.is_stopped()


	var jumped = handle_jump()

	if is_on_floor:
		handle_ground_movement(direction)
	else:
		handle_air_movement(direction)
		handle_spinning()

	if grind_cooldown_timer.is_stopped() and rail_detect_raycast.is_colliding():
		fsm.change_state("GrindState", {"is_speed_boost_active": is_boosting})
		grind_cooldown_timer.start()

	player.move_and_slide()

	var was_on_floor = is_on_floor
	var is_currently_on_floor = player.is_on_floor()

	if !jumped and was_on_floor and !is_currently_on_floor and player.velocity.y > 0:
		coyote_timer.start()
	
	if !was_on_floor and is_currently_on_floor:
		var rot := fmod(sprite.rotation_degrees, 360)
		
		if abs(sprite.rotation_degrees) > 300:
			speed_boost_timer.start()
			is_boosting = true

		if rot > 300 or rot < 60:
			sprite.rotation = 0;
		else:
			player.die(false)


func get_max_speed():
	if player.is_on_floor():
		if speed_boost_timer.is_stopped():
			return player.MAX_GROUND_SPEED
		else:
			return player.MAX_GROUND_SPEED + player.SPEED_BOOST_ADDITION_TO_MAX_SPEED
	
	if speed_boost_timer.is_stopped():
		return player.MAX_AIR_SPEED
	else:
		return player.MAX_AIR_SPEED + player.SPEED_BOOST_ADDITION_TO_MAX_SPEED


func get_acceleration():
	if player.is_on_floor():
		if !is_boosting:
			return player.ACCELERATION
		else:
			return player.SPEED_BOOST_ACCELERATION
	
	if !is_boosting:
		return player.AIR_ACCELERATION
	else:
		return player.SPEED_BOOST_ACCELERATION


func handle_ground_movement(direction: float):
	if direction:
		player.velocity.x = move_toward(player.velocity.x, get_max_speed() * direction, get_acceleration())
		anim.play("run")
	else:
		player.apply_friction()
		anim.play("idle")


func handle_air_movement(direction: float):
	anim.play("jump")

	player.apply_gravity()

	# if direction:
	# 	player.velocity.x = move_toward(player.velocity.x, get_max_speed() * direction, get_acceleration())
	# else:
	player.apply_friction()


func handle_spinning():
	var direction := Input.get_axis("up", "down")
	sprite.rotation += PI / 15 * direction


func handle_jump():
	if Input.is_action_pressed("jump"): jump_buffer_timer.start()

	if !player.is_on_floor() and coyote_timer.is_stopped(): return false

	if !jump_buffer_timer.is_stopped() and jump_cooldown_timer.is_stopped():
		jump_cooldown_timer.start()
		jump_buffer_timer.stop()
		coyote_timer.stop()
		player.velocity.y += player.JUMP_VELOCITY
		return true
