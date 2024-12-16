extends CharacterBody2D


const MAX_MANUAL_SPEED := 100.0
const ACCELERATION := 10.0
const JUMP_VELOCITY := -100.0

const DOWN_SLOPE_SPEED_X := 5.0
const DOWN_SLOPE_SPEED_Y := 5.0

const FRICTION := 0.05
const AIR_FRICTION := 0.1
const GRAVITY := 200.0

@export var slope_check_raycast: RayCast2D
@export var sprite: Sprite2D

func _physics_process(delta: float) -> void:
	if is_on_floor():
		handle_ground_movement(delta)
	else:
		handle_air_movement(delta)

	move_and_slide()


func handle_ground_movement(delta: float):
	var slope_check_normal := slope_check_raycast.get_collision_normal()

	sprite.rotation = slope_check_normal.angle() + PI / 2

	var is_on_left_uphill: bool = abs(rad_to_deg(slope_check_normal.angle())) < 80.0
	var is_on_right_uphill: bool = abs(rad_to_deg(slope_check_normal.angle())) > 100.0

	var is_on_left_downhill := is_on_right_uphill
	var is_on_right_downhill := is_on_left_uphill

	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")

	if direction:
		velocity.x += direction * ACCELERATION
	elif is_on_left_downhill || is_on_right_downhill:
		velocity += Vector2.DOWN * DOWN_SLOPE_SPEED_Y
		velocity += (Vector2.RIGHT if is_on_right_downhill else Vector2.LEFT) * DOWN_SLOPE_SPEED_X
	else:
		velocity.x = move_toward(velocity.x, 0, delta * FRICTION)
	


func handle_air_movement(delta: float):
	velocity += Vector2.DOWN * GRAVITY * delta
	velocity.x = move_toward(velocity.x, 0, delta * FRICTION)
