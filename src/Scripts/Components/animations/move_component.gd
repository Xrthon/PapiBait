# move_component.gd
class_name MoveComponent
extends Node

enum Axis { X, Y, XY, PATH }

@export var target: Node2D
@export var auto_start := false

@export_group("Mouvement")
@export var axis: Axis = Axis.X
@export var distance_x := 200.0           
@export var distance_y := 200.0          
@export var path: Path2D                 

@export_group("Timing")
@export_range(0.05, 20.0, 0.05, "suffix:s") var duration := 1.0
@export_range(0.0, 10.0, 0.05, "suffix:s") var pause := 0.0
@export_range(0.0, 10.0, 0.05, "suffix:s") var start_delay := 0.0
@export var ping_pong := true            

@export_group("Courbe")
@export var transition: Tween.TransitionType = Tween.TRANS_SINE
@export var easing: Tween.EaseType = Tween.EASE_IN_OUT

var _tween: Tween
var _start_pos: Vector2

func _ready() -> void:
	if target == null:
		target = get_parent() as Node2D
	_start_pos = target.position
	if auto_start:
		activate()

func activate() -> void:
	if _tween and _tween.is_running():
		return
	if axis == Axis.PATH and (path == null or path.curve == null):
		push_warning("MoveComponent : axis = PATH mais aucun Path2D assigné.")
		return

	_tween = create_tween().set_loops()
	_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	_tween.set_trans(transition).set_ease(easing)

	if start_delay > 0.0:
		_tween.tween_interval(start_delay)
		
		_tween.tween_callback(func(): start_delay = 0.0)

	if axis == Axis.PATH:
		_build_path_tween()
	else:
		_build_linear_tween()

func _build_linear_tween() -> void:
	var end_pos := _start_pos + _get_offset()
	_tween.tween_property(target, "position", end_pos, duration)
	_tween.tween_interval(pause)
	if ping_pong:
		_tween.tween_property(target, "position", _start_pos, duration)
		_tween.tween_interval(pause)
	else:
		_tween.tween_callback(func(): target.position = _start_pos)

func _build_path_tween() -> void:
	var length := path.curve.get_baked_length()
	_tween.tween_method(_set_path_progress, 0.0, length, duration)
	_tween.tween_interval(pause)
	if ping_pong:
		_tween.tween_method(_set_path_progress, length, 0.0, duration)
		_tween.tween_interval(pause)

func _set_path_progress(d: float) -> void:
	target.global_position = path.to_global(path.curve.sample_baked(d))

func _get_offset() -> Vector2:
	match axis:
		Axis.X:  return Vector2(distance_x, 0)
		Axis.Y:  return Vector2(0, distance_y)
		Axis.XY: return Vector2(distance_x, distance_y)
	return Vector2.ZERO

func deactivate(reset := false) -> void:
	if _tween:
		_tween.kill()
	if reset:
		target.position = _start_pos
