extends CharacterBody2D
class_name Enemy

var death_effect = preload("res://scenes/effects/zombie_death_effect.tscn")
@export var sprite: Sprite2D


func _ready() -> void:
	sprite.flip_h = randf() > 0.5


func die():
	var de: CPUParticles2D = death_effect.instantiate()
	de.emitting = true
	de.global_position = global_position
	Utils.get_level_root().add_child(de)
	queue_free()
