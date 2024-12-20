extends CharacterBody2D


const MAX_MANUAL_SPEED := 60.0
const ACCELERATION := 6.0
const JUMP_VELOCITY := -100.0

const DOWN_SLOPE_SPEED_X := 5.0
const DOWN_SLOPE_SPEED_Y := 5.0

const FRICTION := 0.02
const AIR_FRICTION := 0.1
const GRAVITY := 12

@export var slope_check_raycast: RayCast2D
@export var sprite: Sprite2D
@export var debug_line: Line2D

func _physics_process(_delta: float) -> void:

	if is_on_floor():
		handle_ground_movement()
	else:
		handle_air_movement()

	debug_line.rotation = velocity.angle()

	move_and_slide()


func handle_ground_movement():
	var floor_normal := get_floor_normal()

	sprite.rotation = floor_normal.angle() + PI / 2

	var is_on_left_uphill: bool = abs(rad_to_deg(floor_normal.angle())) < 80.0
	var is_on_right_uphill: bool = abs(rad_to_deg(floor_normal.angle())) > 100.0

	var is_on_left_downhill := is_on_right_uphill
	var is_on_right_downhill := is_on_left_uphill

	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")

	if direction:
		velocity.x += direction * ACCELERATION

	if (is_on_right_downhill && velocity.x > 0) || (is_on_left_downhill && velocity.x < 0):
		velocity.x += direction * ACCELERATION
	
	if (is_on_left_uphill && velocity.x < 0) || (is_on_right_uphill && velocity.x > 0):
		velocity.x = move_toward(velocity.x, 0, FRICTION)

	# if is_on_left_downhill || is_on_right_downhill:
	# 	velocity += Vector2.DOWN * GRAVITY 
	# 	# velocity = velocity.rotated(get_floor_angle())
	# else:
	# 	velocity.x = move_toward(velocity.x, 0, FRICTION)





func apply_gravity():
	velocity += Vector2.DOWN * GRAVITY 


func handle_air_movement():
	apply_gravity()
	# velocity.x = move_toward(velocity.x, 0,  * FRICTION)
