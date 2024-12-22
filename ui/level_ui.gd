extends CanvasLayer
class_name LevelUI

@onready var level: Level = owner

## Countdown
@export_category("Countdown")
@export var countdown_text: RichTextLabel
@export var countdown_container: Control

@export_category("Timer")
@export var timer_text: RichTextLabel

@export_category("Goal")
@export var goal_container: Control
@export var gold_goal_display: MedalGoalDisplay
@export var silver_goal_display: MedalGoalDisplay
@export var bronze_goal_display: MedalGoalDisplay

@export var your_time_display: RichTextLabel
@export var your_rank_display: Medal
@export var personal_best_display: RichTextLabel

@export var try_again_button: Button
@export var next_level_button: Button

@onready var main := Utils.get_main()

func initialize():
	goal_container.visible = false

	if main == null: return

	var level_res = main.current_level

	gold_goal_display.update_display(Medal.Rank.GOLD, level_res.gold_time_seconds)
	silver_goal_display.update_display(Medal.Rank.SILVER, level_res.silver_time_seconds)
	bronze_goal_display.update_display(Medal.Rank.BRONZE, level_res.bronze_time_seconds)


func set_countdown_number(cd: int):
	countdown_text.text = "[center]" + str(cd)


func set_timer_text(elapsed_time_seconds: float):
	timer_text.text = "[center]" + Utils.format_timer_time(elapsed_time_seconds)


func do_countdown():
	countdown_container.visible = true
	set_countdown_number(3)
	await get_tree().create_timer(0.5).timeout
	set_countdown_number(2)
	await get_tree().create_timer(0.5).timeout
	set_countdown_number(1)
	await get_tree().create_timer(0.5).timeout
	countdown_container.visible = false


func show_run_data(player_time):
	goal_container.visible = true
	timer_text.visible = false
	try_again_button.grab_focus()
	next_level_button.visible = main.has_next_level()

	your_time_display.text = "Your time: " + Utils.format_timer_time(player_time)
	
	var rank = main.current_level.get_rank(player_time)

	if rank != null:
		your_rank_display.medal_rank = rank
		your_rank_display.visible = true
	else:
		your_rank_display.visible = false

	personal_best_display.text =  "Personal best: " + Utils.format_timer_time(PersonalBest.get_personal_best(Utils.get_main().current_level))
