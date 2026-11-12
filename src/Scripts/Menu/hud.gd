extends CanvasLayer

@onready var pause_menu : Control = $PauseMenu
@onready var main_menu : Control = $MainMenu
@onready var options_menu : Control = $OptionsMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_all_menus(true)

func hide_all_menus(state: bool): 
	var  allMenus : Array = get_children()
	for menu in allMenus:
		menu.visible = !state
		
func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if visible:
			pause_menu.open()
		get_viewport().set_input_as_handled()

func show_options_menu() -> void: 
	get_tree().paused = true
	options_menu.open()
	print("Menu option ouvert")

func show_main_menu() -> void: 
	get_tree().paused = true
	main_menu.open()
	print("Main menu ouvert")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
