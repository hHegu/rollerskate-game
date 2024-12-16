extends RigidBody2D
class_name Player

@export var angular_speed := 1000
@export var max_speed := 400
@export var jump_strength := 6000

@export var sprite: Sprite2D
@export var floor_check: RayCast2D

var is_on_floor := false
var contact_normal: Vector2
var max_jump_angle := deg_to_rad(20)


func _physics_process(delta: float) -> void:
	var dir := Input.get_axis("left", "right")

	sprite.global_position = global_position
	is_on_floor = (get_contact_count() > 0) or floor_check.is_colliding()

	var velocity_signed = signf(linear_velocity.x)

	if velocity_signed != 0:
		sprite.scale.x = velocity_signed
	
	if abs(dir) > 0:
		if is_on_floor:
			move_character(dir, delta)
		else:
			spin_character(dir, delta)
	
	if Input.is_action_pressed("jump") and is_on_floor:
		print(contact_normal)

		var jump_impulse_dir = Vector2.UP

		if contact_normal != null:
			jump_impulse_dir = contact_normal.clamp(Vector2.UP.rotated(-max_jump_angle), Vector2.UP.rotated(max_jump_angle))
			
		apply_impulse(jump_impulse_dir * jump_strength)


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if state.get_contact_count() > 0:
		contact_normal = state.get_contact_local_normal(0)
		sprite.rotation = contact_normal.angle() + PI / 2


func move_character(direction, delta):
	if abs(angular_velocity) > max_speed: return

	apply_torque_impulse(direction * angular_speed * delta * 60)


func spin_character(direction, delta):
	sprite.rotation = sprite.rotation + (direction * (PI / 17) * delta * 60)
	apply_torque_impulse(direction * angular_speed * delta * 60)