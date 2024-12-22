extends Node2D

@export var anim: AnimationPlayer

@onready var fire_cooldown_timer := Utils.create_timer(self, 0.15)

var bullet_preload = preload("res://scenes/misc/bullet.tscn")


var is_using_controller := true


func _physics_process(_delta: float) -> void:
	# handle_aim_direction()

	if Input.is_action_pressed("fire"):
		fire()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		is_using_controller = false

	if event is InputEventJoypadButton or event is InputEventMouseMotion:
		is_using_controller = true



func handle_aim_direction():
	if is_using_controller:
		var input_vector = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down", 0.3)

		if input_vector.length() == 0: return

		global_rotation = input_vector.angle()
		fire()
	else:
		global_rotation = (get_global_mouse_position() - global_position).angle()



func fire():
	if !fire_cooldown_timer.is_stopped(): return
	fire_cooldown_timer.start()
	anim.play("shoot")

	var bullet: Bullet = bullet_preload.instantiate()
	bullet.dir = Vector2.RIGHT.rotated(global_rotation)
	bullet.global_position = global_position + Vector2.RIGHT.rotated(rotation).normalized() * 5
	Utils.get_level_root().add_child(bullet)

	await anim.animation_finished

	anim.play("idle")
