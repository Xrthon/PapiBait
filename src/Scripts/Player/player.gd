
class_name Player
extends CharacterBody2D
 
#Variable en attente du chargement de scene 
@onready  var player_animation: AnimatedSprite2D = $Animation
@onready var health_component: HealthComponent = $HealthComponent

const MAX_SPEED :float = 200.0
const JUMP_VELOCITY :float = -300.0
const ACCEL :float = 1
const GROUND_ACCEL :float = 0.25
const AIR_ACCEL :float = 0.1
var direction: float = 0.0
var facing_right: bool = true

func _ready() -> void:
	health_component.healed.connect(_on_healed)
func _on_healed():
	pass
func _physics_process(delta: float) -> void:
	_move_with_inputs(delta)
	if _step_on_special_tile("deadly"): 
		health_component.insta_kill();

func _step_on_special_tile(custom_data_name: String) -> bool: 
	if  is_on_floor():
		var collision = get_slide_collision(0)
		if collision:
			var tilemap := collision.get_collider()
			var hit_pos = collision.get_position() - collision.get_normal() * 2.0
			var cell = tilemap.local_to_map(tilemap.to_local(hit_pos))
			var data = tilemap.get_cell_tile_data(cell)
			
			if data and  tilemap.tile_set.has_custom_data_layer_by_name(custom_data_name):
				if data.get_custom_data(custom_data_name): 
					return true
	return false 
func _move_with_inputs(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	direction = Input.get_axis("left", "right")
	velocity.x = ( direction * MAX_SPEED )

	if direction > 0:
		facing_right = true
	elif direction < 0:
		facing_right = false
		
	get_animated_sprite().flip_h = not facing_right
	move_and_slide()

func get_animated_sprite() -> AnimatedSprite2D:
	return $Animation
