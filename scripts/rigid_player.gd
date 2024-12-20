extends RigidBody2D

@export var angular_speed := 1500
@export var max_speed := 350
@export var jump_strength := 8000
@export var max_jump_speed := -300

@export var sprite: Sprite2D
@export var floor_check: RayCast2D

var is_on_floor := false
var contact_normal: Vector2
var max_jump_angle := deg_to_rad(20)

@onready var jump_cooldown_timer := Utils.create_timer(self, 0.05)

enum State {
	DEFAULT,
	GRIND
}

func _physics_process(delta: float) -> void:
	var dir_x := Input.get_axis("left", "right")
	var dir_y := Input.get_axis("up", "down")

	sprite.global_position = global_position
	is_on_floor = (get_contact_count() > 0) or floor_check.is_colliding()

	# var velocity_signed = signf(linear_velocity.x)

	# if velocity_signed != 0:
	# 	sprite.scale.x = velocity_signed
	
	if abs(dir_x) > 0 and is_on_floor:
		move_character(dir_x, delta)

	if abs(dir_x) and !is_on_floor:
		spin_character(dir_x, delta)
	
	if Input.is_action_pressed("jump") and is_on_floor and jump_cooldown_timer.is_stopped():
		jump()


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if state.get_contact_count() > 0:
		contact_normal = state.get_contact_local_normal(0)
		sprite.rotation = contact_normal.angle() + PI / 2
	
	print(linear_velocity.y)
	
	if linear_velocity.y < max_jump_speed:
		linear_velocity.y = max_jump_speed


func move_character(direction, delta):
	if abs(angular_velocity) > max_speed: return

	apply_torque_impulse(direction * angular_speed * delta * 60)


func spin_character(direction, delta):
	sprite.rotation = sprite.rotation + (direction * (PI / 17) * delta * 60) * get_facing_direction()


func jump():
	var jump_impulse_dir = Vector2.UP

	if contact_normal != null:
		jump_impulse_dir = contact_normal.clamp(Vector2.UP.rotated(-max_jump_angle), Vector2.UP.rotated(max_jump_angle))
		
	apply_impulse(jump_impulse_dir * jump_strength)
	jump_cooldown_timer.start()


func get_facing_direction():
	return sprite.scale.x