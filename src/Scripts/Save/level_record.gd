class_name LevelRecord
extends Resource

@export var level_uid : String = ""
@export var completion_time : float = 0.0
@export var death_count : int = 0
@export var date : String = ""

func _init(record_level_uid : String = "", record_completion_time : float = 0.0, record_death_count : int = 0, record_date : String = "") -> void:
	level_uid = record_level_uid
	completion_time = record_completion_time
	death_count = record_death_count
	date = record_date

func is_better_than(other_record : LevelRecord) -> bool:
	if death_count != other_record.death_count:
		return death_count < other_record.death_count
	return completion_time < other_record.completion_time
