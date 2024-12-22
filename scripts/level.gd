extends Node2D
class_name Level

@export var level_ui: LevelUI
@export var goal: Area2D
@export var player: Player

const TIMER_WAIT_TIME := 9999.0

@onready var timer := Utils.create_timer(self, TIMER_WAIT_TIME)
@onready var main := Utils.get_main()


func _ready() -> void:
	goal.body_entered.connect(on_goal_reached)
	level_ui.initialize()
	player.player_died.connect(on_player_died)

	countdown()


func on_goal_reached(_body: Node2D):
	var player_time = get_elapsed_time()

	player_time += get_tree().get_node_count_in_group("enemy") * 2

	if main != null:
		PersonalBest.add_personal_best(main.current_level, player_time)

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


func on_player_died():
	await get_tree().create_timer(0.5).timeout
	level_ui.show_run_data(null)


func _physics_process(_delta: float) -> void:
	level_ui.set_timer_text(get_elapsed_time())

	if Input.is_action_just_pressed("reset"):
		main.restart_level()
