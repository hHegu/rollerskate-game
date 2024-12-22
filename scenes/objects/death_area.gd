extends Area2D

@export var evaporate := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_player_enter)


func on_player_enter(body):
	if body is Player:
		body.die(evaporate)