class_name DebugOverlay
extends PanelContainer

@export var refresh_interval : float = 0.25

@onready var fps_value : Label = %FpsValue
@onready var memory_current_value : Label = %MemoryCurrentValue
@onready var memory_max_value : Label = %MemoryMaxValue
@onready var memory_min_value : Label = %MemoryMinValue

var memory_min_bytes : int = 0
var memory_max_bytes : int = 0
var time_since_refresh : float = 0.0

func _ready() -> void:
	hide()
	memory_min_bytes = OS.get_static_memory_usage()
	memory_max_bytes = memory_min_bytes

func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("toggle_debug_overlay"):
		visible = not visible
		time_since_refresh = refresh_interval
		get_viewport().set_input_as_handled()

func _process(delta : float) -> void:
	var memory_current_bytes : int = OS.get_static_memory_usage()
	memory_min_bytes = mini(memory_min_bytes, memory_current_bytes)
	memory_max_bytes = maxi(memory_max_bytes, memory_current_bytes)
	if not visible:
		return
	time_since_refresh += delta
	if time_since_refresh < refresh_interval:
		return
	time_since_refresh = 0.0
	fps_value.text = str(Engine.get_frames_per_second())
	memory_current_value.text = String.humanize_size(memory_current_bytes)
	memory_max_value.text = String.humanize_size(memory_max_bytes)
	memory_min_value.text = String.humanize_size(memory_min_bytes)
