class_name LeaderboardData
extends Resource

const MAX_RECORDS_PER_LEVEL : int = 5

@export var records : Array[LevelRecord] = []

func add_record(new_record : LevelRecord) -> bool:
	records.append(new_record)
	var level_records : Array[LevelRecord] = get_level_records(new_record.level_uid)
	while level_records.size() > MAX_RECORDS_PER_LEVEL:
		records.erase(level_records.pop_back())
	return records.has(new_record)

func get_level_records(level_uid : String) -> Array[LevelRecord]:
	var level_records : Array[LevelRecord] = []
	for record in records:
		if record.level_uid == level_uid:
			level_records.append(record)
	level_records.sort_custom(func(first_record : LevelRecord, second_record : LevelRecord) -> bool: return first_record.is_better_than(second_record))
	return level_records

func get_best_record(level_uid : String) -> LevelRecord:
	var level_records : Array[LevelRecord] = get_level_records(level_uid)
	if level_records.is_empty():
		return null
	return level_records[0]
