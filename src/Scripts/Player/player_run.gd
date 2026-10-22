class_name PlayerRun
extends BaseState


@export var player : Player
var anim_player : AnimatedSprite2D


func _input(event: InputEvent) -> void:
	handle_inputs(event)

func handle_inputs(input_event: InputEvent) -> void :
	player.direction = Input.get_axis("left", "right")
	
	if input_event.is_action_pressed("attack") and player.is_on_floor():
		Transitioned.emit(self, "PlayerAttack")
		return
		
	if input_event.is_action_pressed("up") and player.is_on_floor():
		Transitioned.emit(self, "PlayerJump")
		return

func update(delta : float) -> void:
	if not anim_player :
		anim_player = player.get_animated_sprite()

	if player.direction != 0:
		player.velocity.x =  lerp(player.velocity.x, player.MAX_SPEED * player.direction, (player.ACCEL * 1.0) / player.MAX_SPEED)
	else :
		player.velocity.x = lerp(player.velocity.x, 0.0, 0.2)

	if (player.velocity.x == 0) :
		Transitioned.emit(self, "PlayerIdle")

	player.facing_right = player.direction > 0

func physics_update(delta: float) -> void:
	if (player.velocity.x != 0):
		player.facing_right = player.velocity.x > 0
		if not anim_player : return

		anim_player.play("Run")

func enter() -> void:
	# Called when entering this state
	pass

func exit() -> void:
	# Called when exiting this state
	pass
