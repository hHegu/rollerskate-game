extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(func(): Utils.get_main().go_to_next_level())
