class_name ControlsMenu
extends Control

const MAIN_MENU_SCENE : String = "res://Scenes/Menu/main_menu.tscn"
const CONTROL_ACTIONS : Array = [
	{ "action": &"left", "description": "Aller à gauche" },
	{ "action": &"right", "description": "Aller à droite" },
	{ "action": &"up", "description": "Sauter" },
	{ "action": &"attack", "description": "Attaquer" },
	{ "action": &"ui_cancel", "description": "Pause" },
	{ "action": &"mute", "description": "Couper le son" },
	{ "action": &"toggle_fullscreen", "description": "Plein écran" },
	{ "action": &"toggle_debug_overlay", "description": "Données techniques" },
	{ "action": &"finish_level", "description": "Finir le niveau (test)", "debug_only": true },
]
const KEY_NAMES : Dictionary = {
	KEY_SPACE: "Espace",
	KEY_ESCAPE: "Échap",
	KEY_ENTER: "Entrée",
	KEY_LEFT: "Flèche gauche",
	KEY_RIGHT: "Flèche droite",
	KEY_UP: "Flèche haut",
	KEY_DOWN: "Flèche bas",
}
const MOUSE_BUTTON_NAMES : Dictionary = {
	MOUSE_BUTTON_LEFT: "Clic gauche",
	MOUSE_BUTTON_RIGHT: "Clic droit",
	MOUSE_BUTTON_MIDDLE: "Clic molette",
}

@onready var controls_grid : GridContainer = %ControlsGrid
@onready var back_button : TextureButton = %BackButton

func _ready() -> void:
	back_button.pressed.connect(_on_back_pressed)
	_build_controls_grid()
	back_button.grab_focus.call_deferred()

func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		_on_back_pressed()

func _build_controls_grid() -> void:
	for control_action in CONTROL_ACTIONS:
		var action_name : StringName = control_action["action"]
		if control_action.get("debug_only", false) and not OS.is_debug_build():
			continue
		if not InputMap.has_action(action_name):
			continue
		var key_texts : PackedStringArray = _get_action_key_texts(action_name)
		if key_texts.is_empty():
			continue
		_add_cell(control_action["description"], &"")
		_add_cell(" / ".join(key_texts), &"ControlKeyLabel")

func _get_action_key_texts(action_name : StringName) -> PackedStringArray:
	var key_texts : PackedStringArray = []
	for input_event in InputMap.action_get_events(action_name):
		var key_text : String = _get_event_text(input_event)
		if not key_text.is_empty() and not key_texts.has(key_text):
			key_texts.append(key_text)
	return key_texts

func _get_event_text(input_event : InputEvent) -> String:
	if input_event is InputEventKey:
		var key_event : InputEventKey = input_event
		var keycode : Key = key_event.keycode
		if key_event.physical_keycode != KEY_NONE:
			keycode = DisplayServer.keyboard_get_keycode_from_physical(key_event.physical_keycode)
		return KEY_NAMES.get(keycode, OS.get_keycode_string(keycode))
	if input_event is InputEventMouseButton:
		var mouse_event : InputEventMouseButton = input_event
		return MOUSE_BUTTON_NAMES.get(mouse_event.button_index, "")
	return ""

func _add_cell(text : String, type_variation : StringName) -> void:
	var cell : Label = Label.new()
	cell.text = text
	cell.theme_type_variation = type_variation
	controls_grid.add_child(cell)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)
