extends CanvasLayer

@onready var pause_menu : Control = $PauseMenu
@onready var main_menu : Control = $MainMenu
@onready var options_menu : Control = $OptionsMenu
@export var full_life_texture : Texture2D
@export var empty_life_texture : Texture2D

@onready var level_info : Control = %LevelInfo
@onready var level_label : Label = %LevelLabel
@onready var health_icons : HBoxContainer = %HealthIcons
@onready var timer_label : Label = %TimerLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_all_menus(true)
	level_info.hide()
	GameManager.current_level_changed.connect(_on_current_level_changed)
	GameManager.player_died.connect(level_info.hide)
	GameManager.player_health_changed.connect(_on_player_health_changed)
	GameManager.level_victory_started.connect(_on_level_victory_started)

func hide_all_menus(state: bool): 
	for menu in [pause_menu, main_menu, options_menu]:
		menu.visible = !state
		
func is_fullscreen() -> bool:
	var window_mode : DisplayServer.WindowMode = DisplayServer.window_get_mode()
	return window_mode == DisplayServer.WINDOW_MODE_FULLSCREEN or window_mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN

func can_change_fullscreen() -> bool:
	return not Engine.is_embedded_in_editor()

func set_fullscreen(enabled : bool) -> void:
	if not can_change_fullscreen():
		push_warning("Plein écran indisponible : le jeu est intégré à l'éditeur.")
		return
	if enabled:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("toggle_fullscreen"):
		set_fullscreen(not is_fullscreen())
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed("ui_cancel"):
		if visible and GameManager.is_in_level() and not GameManager.is_level_finishing:
			pause_menu.open()
		get_viewport().set_input_as_handled()

func show_options_menu() -> void: 
	get_tree().paused = true
	options_menu.open()
	print("Menu option ouvert")

func show_main_menu() -> void: 
	get_tree().paused = true
	main_menu.open()
	print("Main menu ouvert")

func _process(_delta: float) -> void:
	if level_info.visible:
		timer_label.text = GameManager.format_time(GameManager.level_elapsed_time)

func _on_level_victory_started(_completion_time : float, _death_count : int) -> void:
	level_info.hide()

func _on_current_level_changed(level_number : int) -> void:
	level_label.text = "Niveau %d" % level_number
	level_info.visible = GameManager.is_in_level()

func _on_player_health_changed(health : float, max_health : float) -> void:
	var life_count : int = ceili(max_health)
	var remaining_lives : int = ceili(health)
	while health_icons.get_child_count() < life_count:
		var life_icon : TextureRect = TextureRect.new()
		life_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		health_icons.add_child(life_icon)
	while health_icons.get_child_count() > life_count:
		var extra_icon : Node = health_icons.get_child(health_icons.get_child_count() - 1)
		health_icons.remove_child(extra_icon)
		extra_icon.queue_free()
	for life_index in life_count:
		var life_icon : TextureRect = health_icons.get_child(life_index)
		life_icon.texture = full_life_texture if life_index < remaining_lives else empty_life_texture
