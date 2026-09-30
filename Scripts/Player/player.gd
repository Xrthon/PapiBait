extends CharacterBody2D
class_name Player

#Variable en attente du chargement de scene 
@onready  var player_animation: AnimatedSprite2D = $Animation

#Variable global
const SPEED = 200.0
const JUMP_VELOCITY = -300.0

#Setup du Joueur 
func _setup() -> void: 
	pass 
	
func _physics_process(delta: float) -> void:
	
	#Animation du Joueur selon son mouvement 
	if velocity.y != 0:
			if player_animation.animation != "jump":
				_set_player_animation("jump")
	elif velocity.x > 0 or velocity.x < 0 :
			if player_animation.animation != "walk":
				_set_player_animation("walk")
	else:
			if player_animation.animation != "idle":
				_set_player_animation()

	_move_with_inputs(delta)

func _move_with_inputs(delta : float) -> void: 
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Handle jump.
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var direction = Input.get_axis("left", "right")
	velocity.x = direction * SPEED
	
	move_and_slide();
	
func _set_player_animation(animation : String = "idle") -> void: 
	player_animation.flip_h = velocity.x < 0
	player_animation.play(animation)
