extends Area2D
class_name HurtboxComponent

signal damaged( amount: float)

@export var health_component: HealthComponent

func _ready() -> void:
	pass
	
func apply_damage(amount: float) -> void:
	health_component.damage(amount)
	print(health_component.health)
	damaged.emit(amount)
