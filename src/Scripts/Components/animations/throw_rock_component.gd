# throw_rock_component.gd
class_name ThrowRockComponent
extends Node

enum AimMode { DIRECT, ARC }

@export var rock: Rock
@export var swing: SwingComponent
@export var ropes_to_hide: Array[Node2D] = []
@export var ropes_broken_to_show: Array[Node2D] = []

@export_group("Sons")
@export var sounds_to_stop : Array[AudioStreamPlayer2D] = []
@export var sounds_to_play : Array[AudioStreamPlayer2D] = []

@export_group("Visée")
@export var aim_at_player := true
@export var aim_mode : AimMode = AimMode.DIRECT
@export var throw_speed := 900.0
@export var overshoot_distance := 200.0
@export_range(0.1, 3.0, 0.05, "suffix:s") var flight_time := 0.8   
@export var aim_offset := Vector2(0, -16)    
@export var initial_velocity := Vector2(-1000, -200)    
@export_group("Affichage")
@export var rock_z_index := 10                

var _thrown := false
var is_waiting_for_swing := false

func _ready() -> void:
	for rope in ropes_broken_to_show:
		rope.visible = false

func activate() -> void:
	if _thrown or is_waiting_for_swing:
		return
	if swing and swing.is_active():
		is_waiting_for_swing = true
		await _wait_for_forward_swing()
		is_waiting_for_swing = false
	_thrown = true
	call_deferred("_throw")

func _wait_for_forward_swing() -> void:
	var throw_direction : float = _get_player_horizontal_direction()
	while true:
		var swing_direction : float = await swing.passed_lowest_point
		if throw_direction == 0.0 or swing_direction == throw_direction:
			return

func _get_player_horizontal_direction() -> float:
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return signf(initial_velocity.x)
	return signf(player.global_position.x - rock.global_position.x)

func _throw() -> void:
	var start_velocity := initial_velocity
	var straight_distance := 0.0
	if aim_at_player:
		var player := get_tree().get_first_node_in_group("player") as Node2D
		if player:
			var target_position : Vector2 = player.global_position + aim_offset
			if aim_mode == AimMode.DIRECT:
				var distance_to_target : float = rock.global_position.distance_to(target_position)
				start_velocity = rock.global_position.direction_to(target_position) * throw_speed
				straight_distance = distance_to_target + overshoot_distance
			else:
				start_velocity = _compute_aim(rock.global_position, target_position)

	rock.reparent(get_tree().current_scene)
	rock.z_as_relative = false
	rock.z_index = rock_z_index
	rock.launch(start_velocity, straight_distance)

	for rope in ropes_to_hide:
		rope.visible = false
	for rope in ropes_broken_to_show:
		rope.visible = true
	for sound in sounds_to_stop:
		sound.stop()
	for sound in sounds_to_play:
		sound.play()

func _compute_aim(from: Vector2, target: Vector2) -> Vector2:
	var t := maxf(flight_time, 0.05)
	var d := target - from
	return Vector2(d.x / t, d.y / t - 0.5 * rock.gravity_force * t)
