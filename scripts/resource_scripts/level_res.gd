extends Resource
class_name LevelResource

@export var level_name: String

@export var level_scene: PackedScene

@export var gold_time_seconds: float
@export var silver_time_seconds: float
@export var bronze_time_seconds: float


func get_rank(time_seconds):
    if time_seconds == null:
         return null

    if time_seconds <= gold_time_seconds:
        return Medal.Rank.GOLD
    if time_seconds <= silver_time_seconds:
        return Medal.Rank.SILVER
    if time_seconds <= bronze_time_seconds:
        return Medal.Rank.BRONZE
    else:
        return null