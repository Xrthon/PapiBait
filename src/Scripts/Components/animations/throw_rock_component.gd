# throw_rock_component.gd
class_name ThrowRockComponent
extends Node

@export var rock: Rock
@export var swing: SwingComponent
@export var ropes_to_hide: Array[Node2D] = []
@export var ropes_broken_to_show: Array[Node2D] = []

@export_group("Visée")
@export var aim_at_player := true
@export_range(0.1, 3.0, 0.05, "suffix:s") var flight_time := 0.8   
@export var aim_offset := Vector2(0, -16)    
@export var initial_velocity := Vector2(-1000, -200)    
@export_group("Affichage")
@export var rock_z_index := 10                

var _thrown := false

func _ready() -> void:
	for rope in ropes_broken_to_show:
		rope.visible = false

func activate() -> void:
	if _thrown:
		return
	_thrown = true
	call_deferred("_throw")

func _throw() -> void:
	var start_velocity := initial_velocity
	if aim_at_player:
		var player := get_tree().get_first_node_in_group("player") as Node2D
		if player:
			start_velocity = _compute_aim(rock.global_position, player.global_position + aim_offset)

	rock.reparent(get_tree().current_scene)
	rock.z_as_relative = false
	rock.z_index = rock_z_index
	rock.launch(start_velocity)

	for rope in ropes_to_hide:
		rope.visible = false
	for rope in ropes_broken_to_show:
		rope.visible = true

func _compute_aim(from: Vector2, target: Vector2) -> Vector2:
	var t := maxf(flight_time, 0.05)
	var d := target - from
	return Vector2(d.x / t, d.y / t - 0.5 * rock.gravity_force * t)
