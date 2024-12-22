extends Node

signal bests_updated

var personal_bests = {}

func add_personal_best(level: LevelResource, time: float):
	if !personal_bests.has(level.level_name) or personal_bests[level.level_name] > time:
		personal_bests[level.level_name] = time
		bests_updated.emit()


func get_personal_best(level: LevelResource):
	if personal_bests.has(level.level_name):
		return personal_bests[level.level_name]
	else: 
		return null
