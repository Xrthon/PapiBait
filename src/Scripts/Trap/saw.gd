class_name Saw
extends AnimatableBody2D


@export var offset := Vector2(350, 0)
@export var duration := 6.0

@export var move_offset := Vector2(0, 200)  # déplacement quand activée

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func activate() -> void:
	for child in get_children():
		if child.has_method("activate"):
			child.activate()
