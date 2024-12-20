extends CharacterBody2D
class_name Player

const MAX_GROUND_SPEED := 200.0
const MAX_AIR_SPEED := 250.0
const ACCELERATION := 6.0
const AIR_ACCELERATION := 6.0
const JUMP_VELOCITY := -200.0
const GRIND_SPEED := 200.0

const DOWN_SLOPE_SPEED_X := 5.0
const DOWN_SLOPE_SPEED_Y := 5.0

const FRICTION := 5.0
const AIR_FRICTION := 0.1
const GRAVITY := 12


func apply_gravity():
	velocity += Vector2.DOWN * GRAVITY 


func apply_friction():
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, FRICTION)
	else:
		velocity.x = move_toward(velocity.x, 0, AIR_FRICTION)