extends Node2D

@export var anim: AnimationPlayer

@onready var fire_cooldown_timer := Utils.create_timer(self, 0.2)

var bullet_preload = preload("res://scenes/misc/bullet.tscn")

func _physics_process(_delta: float) -> void:
	global_rotation = (get_global_mouse_position()- global_position).angle()
	# look_at(get_global_mouse_position())

	if Input.is_action_pressed("fire") and fire_cooldown_timer.is_stopped():
		fire()


func fire():
	fire_cooldown_timer.start()
	anim.play("shoot")

	var bullet: Bullet = bullet_preload.instantiate()
	bullet.dir = Vector2.RIGHT.rotated(global_rotation)
	bullet.global_position = global_position + Vector2.RIGHT.rotated(rotation).normalized() * 5
	Utils.get_level_root().add_child(bullet)

	await anim.animation_finished

	anim.play("idle")
