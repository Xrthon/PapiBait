class_name  ChangeLevelDoor
extends Node2D



func _ready() -> void:
	pass
	
func is_completed(body: Node2D) -> bool:
	if body is Player:
		return true 
	return false
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_completed(body) :  
		GameManager.levelCompleted.emit(true)
