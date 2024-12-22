extends CharacterBody2D
class_name Bullet

var dir := Vector2.RIGHT
@export var projectile_speed := 1200.0

@export var damage_area : Area2D

func _ready():
	damage_area.body_entered.connect(on_area_enter)
	rotation = dir.angle()

func _physics_process(_delta):
	velocity = dir * projectile_speed
	move_and_slide()

func on_area_enter(body: Node2D):
	if body is Enemy:
		print("should die?")
		body.die()
	queue_free()
