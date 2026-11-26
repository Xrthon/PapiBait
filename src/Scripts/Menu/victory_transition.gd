class_name VictoryTransition
extends Control

@export var close_duration : float = 1.2
@export var hold_duration : float = 1.4
@export var open_duration : float = 0.8

@onready var overlay : ColorRect = %Overlay
@onready var message : Control = %Message
@onready var stats_label : Label = %StatsLabel

var is_covering : bool = false

func _ready() -> void:
	hide()
	GameManager.level_victory_started.connect(_on_level_victory_started)
	get_tree().scene_changed.connect(_on_scene_changed)

func _on_level_victory_started(completion_time : float, death_count : int) -> void:
	is_covering = true
	stats_label.text = "%s   ·   %d mort%s" % [GameManager.format_time(completion_time), death_count, "s" if death_count > 1 else ""]
	_set_center(_get_player_screen_uv())
	_set_progress(0.0)
	message.modulate.a = 0.0
	show()
	
	var close_tween : Tween = create_tween()
	
	close_tween.tween_method(_set_progress, 0.0, 1.0, close_duration)
	close_tween.tween_property(message, "modulate:a", 1.0, 0.3)
	close_tween.tween_interval(hold_duration)
	close_tween.tween_property(message, "modulate:a", 0.0, 0.25)
	close_tween.tween_callback(GameManager.victory_transition_finished.emit)

func _on_scene_changed() -> void:
	if not is_covering:
		return
	is_covering = false
	_set_center(Vector2(0.5, 0.5))
	var open_tween : Tween = create_tween()
	open_tween.tween_method(_set_progress, 1.0, 0.0, open_duration)
	open_tween.tween_callback(hide)

func _get_player_screen_uv() -> Vector2:
	var player : CanvasItem = get_tree().get_first_node_in_group("player") as CanvasItem
	if player == null:
		return Vector2(0.5, 0.5)
	return player.get_global_transform_with_canvas().origin / get_viewport_rect().size

func _set_center(screen_uv : Vector2) -> void:
	var overlay_material : ShaderMaterial = overlay.material
	var viewport_size : Vector2 = get_viewport_rect().size
	overlay_material.set_shader_parameter("center", screen_uv)
	overlay_material.set_shader_parameter("aspect_ratio", viewport_size.x / viewport_size.y)

func _set_progress(progress : float) -> void:
	var overlay_material : ShaderMaterial = overlay.material
	overlay_material.set_shader_parameter("progress", progress)
