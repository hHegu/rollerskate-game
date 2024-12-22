extends State
@onready var player: Player = owner

@export var sprite: Sprite2D
@export var anim: AnimationPlayer
@export var gun_container: Node2D
@export var speed_boost_effect: CPUParticles2D


func on_state_enter(_data: Dictionary = {}):
	anim.play("death")
	sprite.rotation = 0
	gun_container.visible = false
	speed_boost_effect.emitting = false


func state_physics_process(_delta):
	player.apply_friction()
	player.apply_gravity()
	player.move_and_slide()
