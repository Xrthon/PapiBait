extends TextureButton

@export var button_title : String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CenterContainer/Label.text  = button_title
	pass # Replace with function body.

	
