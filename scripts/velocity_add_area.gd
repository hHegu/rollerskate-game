extends Area2D
class_name VelocityAddArea

@export var added_speed := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_body_entered)


func on_body_entered(body: Node2D):
	if body is Player:
		body.velocity += added_speed