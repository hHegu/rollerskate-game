extends State
@onready var player: Player = owner

@export var sprite: Sprite2D
@export var anim: AnimationPlayer
@export var gun_container: Node2D
@export var speed_boost_effect: CPUParticles2D
@export var death_effect: CPUParticles2D

var should_move := true

func on_state_enter(data: Dictionary = {}):
	should_move = !data.hide_body
	if data.hide_body:
		sprite.visible = false
		death_effect.emitting = true

	anim.play("death")
	sprite.rotation = 0
	gun_container.visible = false
	speed_boost_effect.emitting = false


func state_physics_process(_delta):
	if !should_move: return
	player.apply_friction()
	player.apply_gravity()
	player.move_and_slide()
