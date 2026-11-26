class_name OptionsMenu
extends Control

signal closed

const MASTER_BUS : StringName = &"Master"
const MUSIC_BUS : StringName = &"Music"
const SFX_BUS : StringName = &"SFX"

@onready var master_volume_slider : HSlider = %MasterVolumeSlider
@onready var music_volume_slider : HSlider = %MusicVolumeSlider
@onready var sfx_volume_slider : HSlider = %SfxVolumeSlider
@onready var master_volume_value : Label = %MasterVolumeValue
@onready var music_volume_value : Label = %MusicVolumeValue
@onready var sfx_volume_value : Label = %SfxVolumeValue
@onready var fullscreen_check : CheckBox = %FullscreenCheck
@onready var back_button : TextureButton = %BackButton

func _ready() -> void:
	master_volume_slider.value_changed.connect(_on_volume_changed.bind(master_volume_value, MASTER_BUS))
	music_volume_slider.value_changed.connect(_on_volume_changed.bind(music_volume_value, MUSIC_BUS))
	sfx_volume_slider.value_changed.connect(_on_volume_changed.bind(sfx_volume_value, SFX_BUS))
	fullscreen_check.toggled.connect(_on_fullscreen_toggled)
	back_button.pressed.connect(_on_back_pressed)

func open() -> void:
	_sync_volume_slider(master_volume_slider, master_volume_value, MASTER_BUS)
	_sync_volume_slider(music_volume_slider, music_volume_value, MUSIC_BUS)
	_sync_volume_slider(sfx_volume_slider, sfx_volume_value, SFX_BUS)
	fullscreen_check.set_pressed_no_signal(HUD.is_fullscreen())
	fullscreen_check.disabled = not HUD.can_change_fullscreen()
	fullscreen_check.tooltip_text = "" if HUD.can_change_fullscreen() else "Indisponible quand le jeu tourne dans l'éditeur"
	show()
	master_volume_slider.grab_focus()

func _sync_volume_slider(slider : HSlider, value_label : Label, bus_name : StringName) -> void:
	var bus_index : int = AudioServer.get_bus_index(bus_name)
	var volume : float = 0.0 if AudioServer.is_bus_mute(bus_index) else db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	slider.set_value_no_signal(volume)
	_update_volume_label(value_label, volume)

func _update_volume_label(value_label : Label, volume : float) -> void:
	value_label.text = "%d %%" % roundi(volume * 100.0)

func _on_volume_changed(volume : float, value_label : Label, bus_name : StringName) -> void:
	var bus_index : int = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume))
	AudioServer.set_bus_mute(bus_index, volume <= 0.0)
	_update_volume_label(value_label, volume)

func _on_fullscreen_toggled(enabled : bool) -> void:
	HUD.set_fullscreen(enabled)

func _on_back_pressed() -> void:
	hide()
	closed.emit()
