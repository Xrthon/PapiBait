class_name PlayerAttack
extends BaseState

@export var player : Player
var anim_player : AnimatedSprite2D

func enter():
	anim_player = player.get_animated_sprite()
	anim_player.play("Attack")
	if not anim_player.animation_finished.is_connected(_on_animation_finished):
		anim_player.animation_finished.connect(_on_animation_finished)
		
func _on_animation_finished() -> void:
	transition_to("PlayerIdle")
	pass 
	
	
func _input(event: InputEvent) -> void:
	handle_inputs(event)

func handle_inputs(input_event: InputEvent) -> void :
	
	if input_event.is_action_pressed("up") and player.is_on_floor():
		transition_to("PlayerJump")
		return
		
	player.direction = Input.get_axis("left", "right")
	if (player.direction != 0):
		transition_to("PlayerRun")

func update(_delta: float) -> void:
	if player.health_component.is_dead(): 
		transition_to("PlayerDied")
		return
	if not anim_player :
		anim_player = player.get_animated_sprite()

func physics_update(_delta: float) -> void:
	pass

func exit() -> void:
	pass
