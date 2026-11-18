extends Node2D


@export var world_map := "res://scenes/Levels/World_map/world_map.tscn"
var current_level_uid := ""
var completed_levels: Array[String] = []
signal levelCompleted(is_completed: bool)
	 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	levelCompleted.connect(_on_completed_level)
	pass # Replace with function body.




func _on_completed_level(is_completed: bool)->void: 
	print("this level is : ", is_completed)
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
