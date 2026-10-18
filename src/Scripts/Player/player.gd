
class_name Player
extends CharacterBody2D
 
#Variable en attente du chargement de scene 
@onready  var player_animation: AnimatedSprite2D = $Animation

const MAX_SPEED = 200.0
const JUMP_VELOCITY = -300.0
const ACCEL = 1
const GROUND_ACCEL = 0.25
const AIR_ACCEL = 0.1

var direction: float = 0.0
var facing_right: bool = true

func _physics_process(delta: float) -> void:
	_move_with_inputs(delta)

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
