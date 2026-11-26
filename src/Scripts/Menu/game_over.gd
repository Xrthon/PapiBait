class_name GameOver
extends Control

const MAIN_MENU_SCENE : String = "res://Scenes/Menu/main_menu.tscn"

@export var fade_in_duration : float = 0.8

@onready var black_fade : ColorRect = %BlackFade
@onready var restart_button : TextureButton = %RestartButton
@onready var main_menu_button : TextureButton = %MainMenuButton

var is_leaving : bool = false

func _ready() -> void:
	get_tree().paused = false
	restart_button.pressed.connect(_restart_level)
	main_menu_button.pressed.connect(_go_to_main_menu)
	var intro_tween : Tween = create_tween()
	intro_tween.tween_property(black_fade, "modulate:a", 0.0, fade_in_duration)
	intro_tween.tween_callback(restart_button.grab_focus)

func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()
		_restart_level()

func _restart_level() -> void:
	if is_leaving:
		return
	is_leaving = true
	GameManager.restart_current_level()

func _go_to_main_menu() -> void:
	if is_leaving:
		return
	is_leaving = true
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)
