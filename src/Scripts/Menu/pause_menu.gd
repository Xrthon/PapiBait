class_name PauseMenu
extends Control

@onready var resume_button : TextureButton = %Resume
@onready var options_button : TextureButton = %Options
@onready var main_menu_button : TextureButton = %MainMenu

func _ready() -> void:
	pass
	
func open() -> void:
	show()
	get_tree().paused = true
	resume_button.grab_focus()
		
func close_menu() -> void:
	get_tree().paused = false
	hide()

func _on_resume_button_pressed() -> void:
	grab_focus()
	close_menu()

func _on_options_button_pressed() -> void:
	close_menu()
	HUD.show_options_menu()

func _on_main_menu_button_pressed() -> void:
	close_menu()
	HUD.show_main_menu()
