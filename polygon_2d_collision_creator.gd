@tool
extends Polygon2D

@export var update_collision_checkbox: bool:
	set(value):
		update_collision()

@onready var collision_polygon: CollisionPolygon2D = $StaticBody2D/CollisionPolygon2D

# Called when the node enters the scene tree for the first time.
func update_collision() -> void:	
	collision_polygon.polygon = polygon

func _ready() -> void:
	update_collision()