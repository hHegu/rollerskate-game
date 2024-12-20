extends State

@onready var player: Player = owner

@export var rail_detect_raycast: RayCast2D 
@export var particle_effect: CPUParticles2D
@export var anim: AnimationPlayer

var direction := 0.0

var has_snapped_into_position := false

func on_state_enter(_data: Dictionary = {}):
	var collision_point: = rail_detect_raycast.get_collision_point()
	var input_dir = Input.get_axis("left", "right")
	var velocity_dir = signf(player.velocity.x)

	direction = input_dir if input_dir != 0.0 else velocity_dir if velocity_dir != 0.0 else 1.0

	var tween := get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(player, "global_position", collision_point + (Vector2.RIGHT * direction * 10), 0.05)
	tween.play()

	await tween.finished

	particle_effect.emitting = true

	has_snapped_into_position = true


func on_state_exit():
	particle_effect.emitting = false
	has_snapped_into_position = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func state_physics_process(_delta: float) -> void:
	if !has_snapped_into_position: return

	anim.play("grind")

	player.velocity = Vector2.RIGHT * direction * player.GRIND_SPEED

	if Input.is_action_just_pressed("jump"):
		player.velocity.y = player.JUMP_VELOCITY

	if !rail_detect_raycast.is_colliding() or Input.is_action_just_pressed("jump"):
		fsm.change_state("MoveState")

	player.move_and_slide()
