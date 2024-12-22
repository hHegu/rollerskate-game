extends HBoxContainer
class_name MedalGoalDisplay

@onready var medal: Medal = $Medal
@onready var time_text: RichTextLabel = $RichTextLabel

func update_display(rank: Medal.Rank, time_seconds: float):
	medal.medal_rank = rank
	time_text.text = Utils.format_timer_time(time_seconds)
