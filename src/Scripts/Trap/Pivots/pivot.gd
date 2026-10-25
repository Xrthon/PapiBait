# pivot_preview.gd
@tool
extends Node2D

@export var preview := false:
	set(value):
		preview = value
		_t = 0.0
		if not preview:
			rotation = 0.0   
@export var angle_deg := 35.0
@export var period := 1.6         
@export var phase_delay := 0.0   

var _t := 0.0

func _process(delta: float) -> void:
	if not preview:
		return
	_t += delta
	rotation = sin((_t - phase_delay) * TAU / period) * deg_to_rad(angle_deg)
