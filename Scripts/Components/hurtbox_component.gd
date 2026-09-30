extends Area2D
class_name HurtboxComponent

signal damaged( amount: float)


func _ready() -> void:
	pass
	
func apply_damage(amount: float) -> void:
	damaged.emit(amount)
