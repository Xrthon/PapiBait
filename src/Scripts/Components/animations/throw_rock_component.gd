# throw_rock_component.gd
class_name ThrowRockComponent
extends Node

@export var rock: Rock
@export var initial_velocity := Vector2(-1000, -200)   
@export var swing: SwingComponent                  
@export var ropes_to_hide:  Array[Node2D] = []      
@export var ropes_broken_to_show:  Array[Node2D] = []      


var _thrown := false

func activate() -> void:
	if _thrown:
		return
	_thrown = true
	rock.reparent(get_tree().current_scene)   
	rock.launch(initial_velocity)
	if swing:
		swing.deactivate()
	if ropes_to_hide:
		for rope in ropes_to_hide: 
			pass
			#rope.hide()
		for rope in ropes_broken_to_show:
			pass
			#rope.show()
		pass
