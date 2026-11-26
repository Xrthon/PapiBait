class_name LeaderboardMenu
extends Control

const MAIN_MENU_SCENE : String = "res://Scenes/Menu/main_menu.tscn"

@onready var records_list : VBoxContainer = %RecordsList
@onready var back_button : TextureButton = %BackButton

func _ready() -> void:
	back_button.pressed.connect(_on_back_pressed)
	_build_records_list()
	back_button.grab_focus.call_deferred()

func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		_on_back_pressed()

func _build_records_list() -> void:
	for level_index in GameManager.levels.size():
		var level_uid : String = GameManager.get_level_uid(level_index)
		_add_line("Niveau %d" % (level_index + 1), &"LeaderboardLevelLabel")
		var level_records : Array[LevelRecord] = SaveManager.leaderboard_data.get_level_records(level_uid)
		if level_records.is_empty():
			_add_line("Aucun record")
			continue
		for rank in level_records.size():
			_add_line(_format_record(rank + 1, level_records[rank]))

func _add_line(text : String, type_variation : StringName = &"") -> void:
	var line : Label = Label.new()
	line.text = text
	line.theme_type_variation = type_variation
	records_list.add_child(line)

func _format_record(rank : int, record : LevelRecord) -> String:
	return "%d.   %d mort%s   %s   %s" % [rank, record.death_count, "s" if record.death_count > 1 else "", GameManager.format_time(record.completion_time), record.date]

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)
