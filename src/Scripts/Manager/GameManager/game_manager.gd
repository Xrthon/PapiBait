extends Node

const GAME_OVER_SCENE : String = "res://Scenes/Menu/game_over.tscn"
const MAIN_MENU_SCENE : String = "res://Scenes/Menu/main_menu.tscn"

@export var world_map := "res://scenes/Levels/World_map/world_map.tscn"
@export_file("*.tscn") var levels : Array[String] = []

var current_level_uid := ""
var current_level_index : int = -1
var completed_levels: Array[String] = []
var tracked_level_uid : String = ""
var level_elapsed_time : float = 0.0
var level_death_count : int = 0
var is_changing_scene : bool = false
var is_level_skipped : bool = false
var is_level_finishing : bool = false

signal level_completed()
signal player_died()
signal death_transition_finished()
signal current_level_changed(level_number : int)
signal player_health_changed(health : float, max_health : float)
signal level_victory_started(completion_time : float, death_count : int)
signal victory_transition_finished()

func _ready() -> void:
	level_completed.connect(_on_completed_level)
	player_died.connect(_on_player_died)
	death_transition_finished.connect(_on_death_transition_finished)
	victory_transition_finished.connect(_on_victory_transition_finished)
	
	get_tree().scene_changed.connect(_on_scene_changed)
	
	await get_tree().process_frame
	_on_scene_changed()

func change_scene(scene_path : String) -> void:
	if is_changing_scene:
		return
	is_changing_scene = true
	get_tree().change_scene_to_file.call_deferred(scene_path)

func format_time(seconds : float) -> String:
	var minutes : int = floori(seconds / 60.0)
	return "%02d:%05.2f" % [minutes, seconds - minutes * 60.0]

func notify_player_health_changed(health : float, max_health : float) -> void:
	player_health_changed.emit(health, max_health)

func is_in_level() -> bool:
	return current_level_index >= 0

func get_current_level_number() -> int:
	return current_level_index + 1

func get_level_uid(level_index : int) -> String:
	var scene_path : String = _to_scene_path(levels[level_index])
	return ResourceUID.id_to_text(ResourceLoader.get_resource_uid(scene_path))

func start_level(level_index : int) -> void:
	get_tree().paused = false
	_reset_level_stats()
	if level_index < 0 or level_index >= levels.size():
		change_scene(MAIN_MENU_SCENE)
		return
	change_scene(levels[level_index])

func start_first_level() -> void:
	start_level(0)

func start_next_level() -> void:
	start_level(current_level_index + 1)

func restart_current_level() -> void:
	get_tree().paused = false
	if current_level_uid.is_empty():
		change_scene(MAIN_MENU_SCENE)
		return
	change_scene(current_level_uid)

func _find_level_index(scene_path : String) -> int:
	for level_index in levels.size():
		if _to_scene_path(levels[level_index]) == scene_path:
			return level_index
	return -1

func _to_scene_path(scene_reference : String) -> String:
	if scene_reference.begins_with("uid://"):
		return ResourceUID.get_id_path(ResourceUID.text_to_id(scene_reference))
	return scene_reference

func _on_scene_changed() -> void:
	is_changing_scene = false
	is_level_skipped = false
	is_level_finishing = false
	var current_scene : Node = get_tree().current_scene
	if current_scene == null:
		return
	current_level_index = _find_level_index(current_scene.scene_file_path)
	if is_in_level():
		current_level_uid = ResourceUID.id_to_text(ResourceLoader.get_resource_uid(current_scene.scene_file_path))
		if current_level_uid != tracked_level_uid:
			_reset_level_stats()
			tracked_level_uid = current_level_uid
	current_level_changed.emit(get_current_level_number())

func _unhandled_input(event : InputEvent) -> void:
	if OS.is_debug_build() and is_in_level() and event.is_action_pressed("finish_level"):
		get_viewport().set_input_as_handled()
		skip_current_level()

func skip_current_level() -> void:
	if is_changing_scene or is_level_finishing:
		return
	is_level_skipped = true
	level_completed.emit()

func _process(delta : float) -> void:
	if is_in_level():
		level_elapsed_time += delta

func _reset_level_stats() -> void:
	tracked_level_uid = ""
	level_elapsed_time = 0.0
	level_death_count = 0

func _on_player_died()->void: 
	level_death_count += 1

func _on_death_transition_finished() -> void:
	get_tree().paused = false
	change_scene(GAME_OVER_SCENE)

func _on_completed_level()->void: 
	if is_changing_scene or is_level_finishing:
		return
	if not current_level_uid.is_empty() and not completed_levels.has(current_level_uid):
		completed_levels.append(current_level_uid)
	if not current_level_uid.is_empty() and not is_level_skipped:
		SaveManager.add_level_record(current_level_uid, level_elapsed_time, level_death_count)
	is_level_skipped = false
	is_level_finishing = true
	get_tree().paused = true
	level_victory_started.emit(level_elapsed_time, level_death_count)

func _on_victory_transition_finished() -> void:
	start_next_level()
