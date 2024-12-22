extends CanvasLayer

@export var main_menu: Control
@export var level_select: Control
@export var pause_menu: Control

@export var level_select_button: Button
@export var exit_button: Button

@export var back_to_main_menu_button: Button

@export var level_list: BoxContainer

@onready var level_selection_panel := preload("res://ui/level_selection_panel.tscn")


func _ready() -> void:
	level_select_button.pressed.connect(show_level_select)
	back_to_main_menu_button.pressed.connect(show_main_menu)
	exit_button.pressed.connect(get_tree().quit)

	for level in Utils.get_main().levels:
		var level_selection_panel_i: LevelSelectionPanel = level_selection_panel.instantiate()
		level_selection_panel_i.level_res = level
		level_list.add_child(level_selection_panel_i)
	
	show_main_menu()


func hide_all():
	main_menu.visible = false
	level_select.visible = false
	# pause_menu.visible = false


func show_main_menu():
	hide_all()
	level_select_button.grab_focus()

	main_menu.visible = true


func show_level_select():
	hide_all()
	level_select.visible = true
	back_to_main_menu_button.grab_focus()


func show_pause_menu():
	pause_menu.visible = true
