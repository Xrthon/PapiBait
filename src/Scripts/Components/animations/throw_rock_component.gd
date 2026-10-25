# throw_rock_component.gd
class_name ThrowRockComponent
extends Node

@export var rock: Rock
@export var initial_velocity := Vector2(-1000, -200)   
@export var swing: SwingComponent                  
@export var rope_to_hide: CanvasItem              # optionnel : cache la corde

var _thrown := false

func activate() -> void:
	if _thrown:
		return
	_thrown = true
	rock.reparent(get_tree().current_scene)   # quitte le pivot, garde sa position
	rock.launch(initial_velocity)
	if swing:
		swing.deactivate()
	if rope_to_hide:
		pass
