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
		Transitioned.emit(self, "PlayerJump")
		return
	
	player.direction = Input.get_axis("left", "right")
	if (player.direction != 0):
		Transitioned.emit(self, "PlayerRun")

func update(delta: float) -> void:
	if not anim_player :
		anim_player = player.get_animated_sprite()

func physics_update(delta: float) -> void:
	if not anim_player : return
	anim_player.play("Idle")

func exit() -> void:
	pass
