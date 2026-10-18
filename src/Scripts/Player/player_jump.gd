class_name PlayerJump
extends BaseState

@export var player : Player

func enter() -> void:
	if player.is_on_floor():
		player.velocity.y = player.JUMP_VELOCITY
	player.get_animated_sprite().play("Jump")

func physics_update(delta: float) -> void:
	
	player.direction= Input.get_axis("left", "right")
	player.velocity.x = lerp(player.velocity.x, player.MAX_SPEED * player.direction, player.AIR_ACCEL)

	if player.direction != 0:
		player.facing_right = player.direction > 0

	if player.is_on_floor() and player.velocity.y >= 0:
		if player.direction != 0:
			Transitioned.emit(self, "PlayerRun")
		else:
			Transitioned.emit(self, "PlayerIdle")

func handle_inputs(input_event: InputEvent) -> void:
	pass

func update(delta: float) -> void:
	pass

func exit() -> void:
	pass
