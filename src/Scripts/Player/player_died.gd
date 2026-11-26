class_name PlayerDied
extends BaseState

@export var player : Player
var anim_player : AnimatedSprite2D

func enter():
	anim_player = player.get_animated_sprite()
	anim_player.play("Died")

func _input(event: InputEvent) -> void:
	handle_inputs(event)

func handle_inputs(input_event: InputEvent) -> void :
	pass
func update(delta: float) -> void:
	if not anim_player :
		anim_player = player.get_animated_sprite()

func physics_update(delta: float) -> void:
	if anim_player.frame  == 5 :
		anim_player.pause()

func exit() -> void:
	pass
