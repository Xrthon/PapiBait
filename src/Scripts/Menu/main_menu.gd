class_name MainMenu
extends Control

const MAIN_MENU_SCENE : String = "res://Scenes/Menu/main_menu.tscn"
const LEADERBOARD_SCENE : String = "res://Scenes/Menu/leaderboard_menu.tscn"
const CONTROLS_SCENE : String = "res://Scenes/Menu/controls_menu.tscn"

@onready var start_button : TextureButton = %Start
@onready var options_button : TextureButton = %Options
@onready var controls_button : TextureButton = %Controls
@onready var leaderboard_button : TextureButton = %Leaderboard
@onready var quit_button : TextureButton = %Quit

func _ready() -> void:
	if is_visible_in_tree():
		start_button.grab_focus.call_deferred()

func open() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)

func _on_start_pressed() -> void:
	GameManager.start_first_level()

func _on_options_pressed() -> void:
	HUD.options_menu.closed.connect(_on_options_closed, CONNECT_ONE_SHOT)
	HUD.show_options_menu()

func _on_options_closed() -> void:
	get_tree().paused = false
	options_button.grab_focus()

func _on_controls_pressed() -> void:
	get_tree().change_scene_to_file(CONTROLS_SCENE)

func _on_leaderboard_pressed() -> void:
	get_tree().change_scene_to_file(LEADERBOARD_SCENE)

func _on_quit_pressed() -> void:
	get_tree().quit()
