extends Node2D


@onready var down_btn : RigidBody2D = $BoutonDown
@onready var up_btn: RigidBody2D= $BoutonUp
@export  var level_door : ChangeLevelDoor=null
var btn_state = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_button_state(true)

func _set_button_state(is_up : bool) -> void:
	btn_state = is_up
	up_btn.visible = is_up
	down_btn.visible = not is_up


func _on_btn_up_area_area_entered(area: Area2D) -> void:
	var elem_contact = area.get_parent()
	if elem_contact is Player: 
		level_door.open_door.emit()
		_set_button_state(false)


func _on_btn_down_area_area_entered(area: Area2D) -> void:
	var elem_contact = area.get_parent()
	if elem_contact is Player: 
		_set_button_state(false)
