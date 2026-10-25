class_name Saw
extends AnimatableBody2D


@export var offset := Vector2(350, 0)
@export var duration := 6.0

@onready var anim_body : AnimatableBody2D = $Saw
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
	#if _tween:
		#_tween.kill()
	#_tween = create_tween().set_parallel(true)
	#_tween.tween_property(self, "position", position + move_offset, duration) \
		#.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	#_tween.tween_property(self, "rotation", rotation + TAU * 3, duration)
