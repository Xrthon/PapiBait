class_name PlayerIdle
extends BaseState

@export var player : Player
var anim_player : AnimatedSprite2D

func enter():
	anim_player = player.get_animated_sprite()

func _input(event: InputEvent) -> void:
	handle_inputs(event)

func handle_inputs(input_event: InputEvent) -> void :

	if input_event.is_action_pressed("up") and player.is_on_floor():
		transition_to("PlayerJump")
		return
	if input_event.is_action_pressed("attack") and player.is_on_floor():
		transition_to("PlayerAttack")
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
	if not anim_player : return
	anim_player.play("Idle")

func exit() -> void:
	pass
