extends CharacterBody2D
class_name Bullet

var dir := Vector2.RIGHT
@export var projectile_speed := 600.0

@export var damage_area : Area2D

func _ready():
	damage_area.body_entered.connect(func(): queue_free())
	rotation = dir.angle()

func _physics_process(_delta):
	velocity = dir * projectile_speed
	move_and_slide()