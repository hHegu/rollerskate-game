extends PanelContainer
class_name LevelSelectionPanel

@export var gold_goal_display: MedalGoalDisplay
@export var silver_goal_display: MedalGoalDisplay
@export var bronze_goal_display: MedalGoalDisplay

@export var your_best_text: RichTextLabel

@export var level_button: Button

@export var level_res: LevelResource


func _ready() -> void:
	gold_goal_display.update_display(Medal.Rank.GOLD, level_res.gold_time_seconds)
	silver_goal_display.update_display(Medal.Rank.SILVER, level_res.silver_time_seconds)
	bronze_goal_display.update_display(Medal.Rank.BRONZE, level_res.bronze_time_seconds)

	level_button.text = level_res.level_name
	level_button.pressed.connect(func(): Utils.get_main().change_level(level_res))

	update_personal_best()
	
	PersonalBest.bests_updated.connect(update_personal_best)

func update_personal_best():
	var personal_best_time = PersonalBest.get_personal_best(level_res)
	your_best_text.text = "[center]Best\n" + ("--:--" if personal_best_time == null else Utils.format_timer_time(personal_best_time))