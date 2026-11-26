class_name DeathEffectComponent
extends CanvasLayer

@export var health_component : HealthComponent
@export var fade_duration : float = 0.6
@export var hold_duration : float = 0.8
@export var fade_to_black_duration : float = 0.7

@onready var red_overlay : ColorRect = $RedOverlay

func _ready() -> void:
	_set_intensity(0.0)
	_set_darkness(0.0)
	red_overlay.visible = false
	health_component.died.connect(_on_died)
	health_component.revived.connect(_on_revived)

func _on_died() -> void:
	red_overlay.visible = true
	var fade_tween : Tween = create_tween()
	fade_tween.tween_method(_set_intensity, 0.0, 1.0, fade_duration)
	fade_tween.tween_interval(hold_duration)
	fade_tween.tween_method(_set_darkness, 0.0, 1.0, fade_to_black_duration)
	fade_tween.tween_callback(GameManager.death_transition_finished.emit)

func _on_revived() -> void:
	_set_intensity(0.0)
	_set_darkness(0.0)
	red_overlay.visible = false

func _set_intensity(intensity : float) -> void:
	var overlay_material : ShaderMaterial = red_overlay.material
	overlay_material.set_shader_parameter("intensity", intensity)

func _set_darkness(darkness : float) -> void:
	var overlay_material : ShaderMaterial = red_overlay.material
	overlay_material.set_shader_parameter("darkness", darkness)
