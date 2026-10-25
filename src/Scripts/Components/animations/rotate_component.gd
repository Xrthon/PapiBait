class_name RotateComponent
extends Node

@export var target: Node2D
@export var speed := TAU 
@export var auto_start := false

var _active := false

func _ready() -> void:
	if target == null:
		target = get_parent() as Node2D
	_active = auto_start

func activate() -> void:
	_active = true

func deactivate() -> void:
	_active = false

func _physics_process(delta: float) -> void:
	if _active:
		target.rotation += speed * delta
