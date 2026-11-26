extends Area2D
class_name HitboxComponent

signal hit(hurtbox: HurtboxComponent, amount: float)

@export var damage_amount := 5

func _on_hurtbox_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		area.apply_damage(damage_amount)
		hit.emit(area,damage_amount)
	pass # Replace with function body.
