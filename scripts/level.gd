extends Node2D


@export var goal: Area2D
@export var countdown_text: RichTextLabel
@export var countdown_container: Control
@export var timer_text: RichTextLabel
@export var level_resource: LevelResource

@export var goal_container: Control
@export var gold_goal_display: MedalGoalDisplay
@export var silver_goal_display: MedalGoalDisplay
@export var bronze_goal_display: MedalGoalDisplay

@export var your_time_display: RichTextLabel
@export var your_rank_display: Medal

const TIMER_WAIT_TIME := 9999.0

@onready var timer := Utils.create_timer(self, TIMER_WAIT_TIME)

func _ready() -> void:
	goal_container.visible = false
	goal.body_entered.connect(on_goal_reached)

	gold_goal_display.update_display(Medal.Rank.GOLD, level_resource.gold_time_seconds)
	silver_goal_display.update_display(Medal.Rank.SILVER, level_resource.silver_time_seconds)
	bronze_goal_display.update_display(Medal.Rank.BRONZE, level_resource.bronze_time_seconds)

	countdown()


func on_goal_reached(_body: Node2D):
	goal_container.visible = true
	var player_time = get_elapsed_time()

	player_time += get_tree().get_node_count_in_group("enemy") * 2

	your_time_display.text = "Your time: " + Utils.format_timer_time(player_time)
	your_rank_display.medal_rank = level_resource.get_rank(player_time)
	timer_text.visible = false

	Utils.get_player().process_mode = Node.PROCESS_MODE_DISABLED
	timer.stop()


func countdown():
	countdown_container.visible = true
	set_countdown_number(3)
	await get_tree().create_timer(0.5).timeout
	set_countdown_number(2)
	await get_tree().create_timer(0.5).timeout
	set_countdown_number(1)
	await get_tree().create_timer(0.5).timeout
	countdown_container.visible = false
	
	timer.start()

	Utils.get_player().process_mode = Node.PROCESS_MODE_INHERIT


func set_countdown_number(cd: int):
	countdown_text.text = "[center]" + str(cd)


func get_elapsed_time():
	return TIMER_WAIT_TIME - timer.time_left


func _physics_process(_delta: float) -> void:
	timer_text.text = "[center]" + Utils.format_timer_time(get_elapsed_time())
