class_name MainMenu
extends Control

@onready var start : TextureButton = %Start
@onready var options : TextureButton = %Options
@onready var quit : TextureButton = %Quit



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
func open() -> void: 
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")


func _on_start_pressed() ->void:
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
	
func _on_options_pressed() -> void: 
	pass
	
func _on_quit_pressed() -> void: 
	get_tree().quit()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
