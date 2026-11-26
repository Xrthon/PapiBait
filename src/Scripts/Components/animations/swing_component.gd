# swing_component.gd
class_name SwingComponent
extends Node

signal passed_lowest_point(horizontal_direction : float)

@export var pivots: Array[Node2D] = []        
@export var angles_deg: Array[float] = [30.0, 15.0, 8.0]
@export var period := 1.6                     
@export var phase_step := 0.1                 
@export var auto_start := true
@export var swing_sound : AudioStreamPlayer2D

var _active := false
var _t := 0.0
var previous_main_angle := 0.0

func _ready() -> void:
	if auto_start:
		activate()

func activate() -> void:
	_active = true
	if swing_sound and not swing_sound.playing:
		swing_sound.play()

func is_active() -> bool:
	return _active

func deactivate() -> void:
	_active = false
	if swing_sound:
		swing_sound.stop()

func _physics_process(delta: float) -> void:
	if not _active:
		return
	_t += delta
	for i in pivots.size():
		var angle := deg_to_rad(angles_deg[i]) if i < angles_deg.size() else 0.0
		pivots[i].rotation = sin((_t - i * phase_step) * TAU / period) * angle
	_detect_lowest_point()

func _detect_lowest_point() -> void:
	if pivots.is_empty():
		return
	var main_angle : float = pivots[0].rotation
	
	# signf ==> renvoie -1, 0 ou 1.
	var has_crossed_lowest_point : bool = signf(main_angle) != signf(previous_main_angle) and previous_main_angle != 0.0
	if has_crossed_lowest_point:
		passed_lowest_point.emit(-signf(main_angle - previous_main_angle))
	previous_main_angle = main_angle
