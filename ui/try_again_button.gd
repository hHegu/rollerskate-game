extends Button

func _ready() -> void:
	pressed.connect(func(): Utils.get_main().restart_level())
