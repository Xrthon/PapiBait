extends Node2D


@export var world_map := "res://scenes/Levels/World_map/world_map.tscn"
var current_level_uid := ""
var completed_levels: Array[String] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
