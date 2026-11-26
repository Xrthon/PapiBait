# rock.gd
class_name Rock
extends CharacterBody2D

@export var gravity_force := 980.0
@export var friction := 600.0        
@export var wall_bounce := 0.3          
@export var radius := 24.0               
@export var max_roll_angle := TAU
@export var stop_speed := 15.0            
@export var lifetime_after_stop := 2.0   

@export_group("Dégâts")
@export var kills_before_launch := true  
@export var kills_when_stopped := false   

@export_group("Nœuds")
@export var sprite: Node2D
@export var hitbox: Area2D

var _launched := false
var _stopped := false
var rolled_angle := 0.0
var remaining_straight_distance := 0.0

func _ready() -> void:
	set_physics_process(false)   # suspendue au départ
	if sprite == null:
		sprite = get_node_or_null("Sprite2D")
	if hitbox == null:
		hitbox = get_node_or_null("Hitbox")
	if hitbox:
		hitbox.body_entered.connect(_on_hitbox_body_entered)
	else:
		push_warning("Rock : aucune Hitbox (Area2D) trouvée, la roche ne tuera pas.")

func launch(start_velocity: Vector2, straight_distance : float = 0.0) -> void:
	velocity = start_velocity
	remaining_straight_distance = straight_distance
	_launched = true
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	if remaining_straight_distance > 0.0:
		remaining_straight_distance -= velocity.length() * delta
	else:
		velocity.y += gravity_force * delta

	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)

	var speed_x_before := velocity.x
	move_and_slide()
	if get_slide_collision_count() > 0:
		remaining_straight_distance = 0.0

	# Rebond contre un mur
	if is_on_wall():
		velocity.x = -speed_x_before * wall_bounce

	if sprite and is_on_floor():
		_roll(velocity.x * delta / radius)

	if is_on_floor() and absf(velocity.x) < stop_speed:
		_stop()

func _roll(angle_step : float) -> void:
	var next_rolled_angle : float = clampf(rolled_angle + angle_step, -max_roll_angle, max_roll_angle)
	sprite.rotation += next_rolled_angle - rolled_angle
	rolled_angle = next_rolled_angle

func _stop() -> void:
	if _stopped:
		return
	_stopped = true
	velocity = Vector2.ZERO
	set_physics_process(false)
	
	if hitbox and not kills_when_stopped:
		hitbox.set_deferred("monitoring", false)
	if lifetime_after_stop >= 0.0:
		await get_tree().create_timer(lifetime_after_stop).timeout
		queue_free()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	if not _launched and not kills_before_launch:
		return
	body.die()
