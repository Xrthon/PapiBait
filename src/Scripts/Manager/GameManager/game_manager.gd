extends Node2D


@export var world_map := "res://scenes/Levels/World_map/world_map.tscn"
var current_level_uid := ""
var completed_levels: Array[String] = []
signal level_completed()
signal player_died()

	 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_completed.connect(_on_completed_level)
	player_died.connect(_on_player_died)

func _on_player_died()->void: 
	print("HE DIE",get_tree().current_scene.scene_file_path)
	pass
	

func _on_completed_level()->void: 
	print("this level is completed ", get_tree().current_scene.scene_file_path)
	get_tree().reload_current_scene() 
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
