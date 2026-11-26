extends Node

const SAVE_DIRECTORY : String = "user://save/"
const SAVE_FILE_NAME : String = "leaderboard_save.tres"

var leaderboard_data : LeaderboardData = LeaderboardData.new()

func _ready() -> void:
	load_game()

func add_level_record(level_uid : String, completion_time : float, death_count : int) -> bool:
	var new_record : LevelRecord = LevelRecord.new(level_uid, completion_time, death_count, Time.get_datetime_string_from_system(false, true))
	var is_in_leaderboard : bool = leaderboard_data.add_record(new_record)
	save_game()
	return is_in_leaderboard

func save_game() -> void:
	verify_save_directory(SAVE_DIRECTORY)
	var error : Error = ResourceSaver.save(leaderboard_data, _get_save_path())
	if error != OK:
		push_error("Erreur lors de la sauvegarde : " + str(error))

func load_game() -> void:
	var save_path : String = _get_save_path()
	if not ResourceLoader.exists(save_path):
		push_warning("Aucune sauvegarde trouvée : " + ProjectSettings.globalize_path(save_path))
		return
	var loaded_data : LeaderboardData = ResourceLoader.load(save_path, "", ResourceLoader.CACHE_MODE_IGNORE) as LeaderboardData
	if loaded_data == null:
		push_error("Sauvegarde invalide : " + ProjectSettings.globalize_path(save_path))
		return
	leaderboard_data = loaded_data.duplicate(true)

func verify_save_directory(path : String) -> void:
	var error : Error = DirAccess.make_dir_recursive_absolute(path)
	if error != OK:
		push_error("Erreur lors de la création du répertoire de sauvegarde : " + str(error))

func _get_save_path() -> String:
	return SAVE_DIRECTORY.path_join(SAVE_FILE_NAME)
