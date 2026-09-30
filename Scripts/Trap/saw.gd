extends AnimatableBody2D


@export var offset := Vector2(350, 0)
@export var duration := 6.0

@onready var anim_body : AnimatableBody2D = $Saw

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_tween(): 
	var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS) as Tween
	tween.set_loops().set_parallel(true)
	tween.tween_property(anim_body, "position", offset, duration / 2)
	#tween.tween_property(anim_body, "position", Vector2.ZERO, duration)
