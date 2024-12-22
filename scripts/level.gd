extends Node2D
class_name Level

@export var level_ui: LevelUI
@export var goal: Area2D
@export var level_resource: LevelResource


const TIMER_WAIT_TIME := 9999.0

@onready var timer := Utils.create_timer(self, TIMER_WAIT_TIME)

func _ready() -> void:
	goal.body_entered.connect(on_goal_reached)
	level_ui.initialize()

	countdown()


func on_goal_reached(_body: Node2D):
	var player_time = get_elapsed_time()

	player_time += get_tree().get_node_count_in_group("enemy") * 2

	level_ui.show_run_data(player_time)

	Utils.get_player().process_mode = Node.PROCESS_MODE_DISABLED
	timer.stop()


func countdown():
	await level_ui.do_countdown()
	
	timer.start()
	Utils.get_player().process_mode = Node.PROCESS_MODE_INHERIT


func get_elapsed_time():
	if timer.is_stopped():
		return 0.0

	return TIMER_WAIT_TIME - timer.time_left


func _physics_process(_delta: float) -> void:
	level_ui.set_timer_text(get_elapsed_time())
