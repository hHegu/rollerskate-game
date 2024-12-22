extends Resource
class_name LevelResource

@export var level_scene: PackedScene

@export var gold_time_seconds: float
@export var silver_time_seconds: float
@export var bronze_time_seconds: float


func get_rank(time_seconds: float) -> Medal.Rank:
    if time_seconds <= gold_time_seconds:
        return Medal.Rank.GOLD
    if time_seconds <= silver_time_seconds:
        return Medal.Rank.SILVER
    else:
        return Medal.Rank.BRONZE