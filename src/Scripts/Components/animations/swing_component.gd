# swing_component.gd
class_name SwingComponent
extends Node

@export var pivots: Array[Node2D] = []        
@export var angles_deg: Array[float] = [30.0, 15.0, 8.0,25.0]
@export var period := 1.6                     
@export var phase_step := 0.1                 
@export var auto_start := true

var _active := false
var _t := 0.0

func _ready() -> void:
	_active = auto_start

func activate() -> void:
	_active = true

func deactivate() -> void:
	_active = false

func _physics_process(delta: float) -> void:
	if not _active:
		return
	_t += delta
	for i in pivots.size():
		var angle := deg_to_rad(angles_deg[i]) if i < angles_deg.size() else 0.0
		pivots[i].rotation = sin((_t - i * phase_step) * TAU / period) * angle
