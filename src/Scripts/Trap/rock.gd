# rock.gd
class_name Rock
extends Area2D

@export var gravity_force := 980.0
var velocity := Vector2.ZERO
var _launched := false

func _ready() -> void:
	set_physics_process(false)   # suspendue au départ
	body_entered.connect(_on_body_entered)

func launch(start_velocity: Vector2) -> void:
	velocity = start_velocity
	_launched = true
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	velocity.y += gravity_force * delta
	position += velocity * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.die()          # tue même pendant le balancement
	elif _launched:
		queue_free()        # touche le sol après le lancer
