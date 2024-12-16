extends RigidBody2D
class_name Player

@export var angular_speed := 300
@export var max_speed := 100
@export var jump_strength := 10000

@export var wheel_left: RigidBody2D
@export var wheel_right: RigidBody2D
@export var floor_check: RayCast2D

@onready var wheels = [wheel_left, wheel_right]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	var is_on_floor = floor_check.is_colliding()
	var dir := Input.get_axis("left", "right")


	
	if abs(dir) > 0:
		if is_on_floor: 
			spin_wheels(dir, delta)
		else:
			spin_character(dir, delta)
	
	if Input.is_action_just_pressed("jump") and is_on_floor:
		apply_impulse(Vector2.UP * jump_strength)



	# if abs(dir) > 0 && linear_velocity.x < 150.0:
	# 	print(linear_velocity.x)
	# 	print(dir)
	# 	apply_force(Vector2(dir, 0) * 800.0)
	
	# if Input.is_action_just_pressed("jump"):
	# 	print("?")
	# 	apply_force(Vector2.UP * 10000.0)

func spin_wheels(direction, delta):
	for wheel in wheels:
		if abs(wheel.angular_velocity) > max_speed: return
		wheel.apply_torque_impulse(direction * angular_speed * delta * 60)


func spin_character(direction, delta):
	apply_torque_impulse(direction * angular_speed * delta * 60)