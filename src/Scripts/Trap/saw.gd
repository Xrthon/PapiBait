class_name Saw
extends AnimatableBody2D


@export var offset := Vector2(350, 0)
@export var duration := 6.0

@export var move_offset := Vector2(0, 200)  # déplacement quand activée
@export var saw_sound : AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func activate() -> void:
	if saw_sound and not saw_sound.playing:
		saw_sound.play()
	for child in get_children():
		if child.has_method("activate"):
			child.activate()
