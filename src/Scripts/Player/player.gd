
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
const DEATH_FRICTION :float = 800.0
var direction: float = 0.0
var facing_right: bool = true

func _ready() -> void:
	health_component.died.connect(GameManager.player_died.emit)
	health_component.changed.connect(_on_health_changed)
	_on_health_changed(health_component.health)

func _on_health_changed(_new_health : float) -> void:
	GameManager.notify_player_health_changed(health_component.health, health_component.max_life)

func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	if health_component.is_dead():
		velocity.x = move_toward(velocity.x, 0.0, DEATH_FRICTION * delta)
	else:
		_move_with_inputs()
	move_and_slide()
	if _step_on_special_tile("deadly"):
		die()

func die() -> void:
	if health_component.is_dead():
		return
	health_component.insta_kill()

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		var current_gravity := get_gravity() if velocity.y < 0.0 else get_gravity() *1.5
		velocity += current_gravity * delta

func _step_on_special_tile(custom_data_name: String) -> bool:
	if not is_on_floor():
		return false
		
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)

		if collision.get_normal().dot(up_direction) < 0.7:
			continue

		var tilemap := collision.get_collider() as TileMapLayer
		if tilemap == null:
			continue

		if not tilemap.tile_set.has_custom_data_layer_by_name(custom_data_name):
			continue

		var hit_pos := collision.get_position() - collision.get_normal() * 2.0
		var cell := tilemap.local_to_map(tilemap.to_local(hit_pos))
		var data := tilemap.get_cell_tile_data(cell)

		if data and data.get_custom_data(custom_data_name):
			return true

	return false
func _move_with_inputs() -> void:
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	direction = Input.get_axis("left", "right")
	velocity.x = ( direction * MAX_SPEED )

	if direction > 0:
		facing_right = true
	elif direction < 0:
		facing_right = false
		
	get_animated_sprite().flip_h = not facing_right

func get_animated_sprite() -> AnimatedSprite2D:
	return $Animation
