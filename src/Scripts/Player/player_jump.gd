class_name PlayerJump
extends BaseState

@export var player : Player

func enter() -> void:
	if player.is_on_floor():
		player.velocity.y = player.JUMP_VELOCITY
	player.get_animated_sprite().play("Jump")

func physics_update(_delta: float) -> void:
	if player.health_component.is_dead(): 
		transition_to("PlayerDied")
		return
	
	player.direction= Input.get_axis("left", "right")
	player.velocity.x = lerp(player.velocity.x, player.MAX_SPEED * player.direction, player.AIR_ACCEL)

	if player.direction != 0:
		player.facing_right = player.direction > 0

	if player.is_on_floor() and player.velocity.y >= 0:
		if player.direction != 0:
			transition_to("PlayerRun")
		else:
			transition_to("PlayerIdle")

func handle_inputs(_input_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func exit() -> void:
	pass
