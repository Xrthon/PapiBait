# move_component.gd
class_name MoveComponent
extends Node

@export var target: Node2D
@export var distance := 200.0        # en pixels, vers la droite (négatif = vers la gauche)
@export var duration := 1.0          # durée d'un aller
@export var pause := 0.0             # pause à chaque extrémité
@export var auto_start := false

var _tween: Tween
var _start_x: float

func _ready() -> void:
	if target == null:
		target = get_parent() as Node2D
	_start_x = target.position.x
	if auto_start:
		activate()
func activate() -> void:
	if _tween and _tween.is_running():
		return
	_tween = create_tween().set_loops()
	_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS) 
	_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_tween.tween_property(target, "position:x", _start_x + distance, duration)
	_tween.tween_interval(pause)
	_tween.tween_property(target, "position:x", _start_x, duration)
	_tween.tween_interval(pause)

func deactivate() -> void:
	if _tween:
		_tween.kill()
