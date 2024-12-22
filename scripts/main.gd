extends Node2D
class_name Main

@export var levels: Array[LevelResource]

@export var world: Node2D
@export var level_select: VBoxContainer
@export var ui: CanvasLayer
@export var level_transition_anim: AnimationPlayer
# @onready var level: Node2D = $Level

var current_level: LevelResource

func toggle_pause():
	var is_paused = world.process_mode == ProcessMode.PROCESS_MODE_DISABLED
	
	if is_paused:
		unpause()
	else:
		world.process_mode = ProcessMode.PROCESS_MODE_DISABLED
		ui.show_pause_menu()


func unpause():
	ui.hide_all()
	world.process_mode = ProcessMode.PROCESS_MODE_INHERIT


func back_to_main_menu():
	for child in world.get_children():
		world.remove_child(child)
		child.queue_free()
	
	ui.show_level_select()


func change_level(level: LevelResource) -> void:
	level_transition_anim.play("in")
	await level_transition_anim.animation_finished

	for child in world.get_children():
		world.remove_child(child)
		child.queue_free()

	current_level = level
	world.add_child(level.level_scene.instantiate())
	
	level_transition_anim.play("out")
	
	unpause()


func restart_level():
	change_level(current_level)

func has_next_level():
	var current_level_index := levels.find(current_level)
	return current_level_index < levels.size() - 1

func go_to_next_level():
	var current_level_index := levels.find(current_level)
	print(current_level.level_name)
	print(current_level_index)
	if(current_level_index == -1): return
	
	if(current_level_index >= levels.size() - 1):
		ui.show_game_end_screen()
		return
	
	change_level(levels[current_level_index + 1])
