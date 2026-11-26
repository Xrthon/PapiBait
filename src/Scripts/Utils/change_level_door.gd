class_name  ChangeLevelDoor
extends Node2D

signal open_door()

func _ready() -> void:
	open_door.connect(_open_door_with_button)
	pass
	
func is_completed(body: Node2D) -> bool:
	if body is Player:
		return true 
	return false
	
func _open_door_with_button() -> void: 
	%Door.play("opening")
func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_completed(body) :  
		GameManager.level_completed.emit()
