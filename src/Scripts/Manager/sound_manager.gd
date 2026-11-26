extends Node

const LEVEL_SCENES_FOLDER : String = "res://Scenes/Level/"
const MASTER_BUS : StringName = &"Master"
const MUSIC_BUS : StringName = &"Music"
const UI_BUS : StringName = &"UI"
const FULL_VOLUME_DB : float = 0.0
const SILENT_VOLUME_DB : float = -40.0

@export var level_music : AudioStream
@export var menu_music : AudioStream
@export var fade_duration : float = 1.0

@onready var music_player : AudioStreamPlayer = $MusicPlayer
@onready var ui_player : AudioStreamPlayer = $UiPlayer

var fade_tween : Tween

func _ready() -> void:
	music_player.bus = MUSIC_BUS
	ui_player.bus = UI_BUS
	get_tree().scene_changed.connect(_on_scene_changed)
	await get_tree().process_frame
	_on_scene_changed()

func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("mute"):
		toggle_mute()
		get_viewport().set_input_as_handled()

func toggle_mute() -> void:
	var master_bus_index : int = AudioServer.get_bus_index(MASTER_BUS)
	AudioServer.set_bus_mute(master_bus_index, not AudioServer.is_bus_mute(master_bus_index))

func play_music(music : AudioStream) -> void:
	if music == null:
		stop_music()
		return
	if music_player.stream == music and music_player.playing:
		return
	_stop_fade()
	music_player.stream = music
	music_player.volume_db = SILENT_VOLUME_DB
	music_player.play()
	fade_tween = create_tween()
	fade_tween.tween_property(music_player, "volume_db", FULL_VOLUME_DB, fade_duration)

func stop_music() -> void:
	if not music_player.playing:
		return
	_stop_fade()
	fade_tween = create_tween()
	fade_tween.tween_property(music_player, "volume_db", SILENT_VOLUME_DB, fade_duration)
	fade_tween.tween_callback(music_player.stop)

func play_ui_sound(sound : AudioStream) -> void:
	ui_player.stream = sound
	ui_player.play()

func _stop_fade() -> void:
	if fade_tween and fade_tween.is_running():
		fade_tween.kill()

func _is_level_scene(scene : Node) -> bool:
	return scene != null and scene.scene_file_path.begins_with(LEVEL_SCENES_FOLDER)

func _on_scene_changed() -> void:
	if _is_level_scene(get_tree().current_scene):
		play_music(level_music)
	else:
		play_music(menu_music)
