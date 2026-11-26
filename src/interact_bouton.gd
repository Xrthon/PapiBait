extends Node2D


@onready var down_btn : RigidBody2D = $BoutonDown
@onready var up_btn: RigidBody2D= $BoutonUp
@export  var level_door : ChangeLevelDoor=null
var btn_state = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	up_btn.show()
	down_btn.hide()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if btn_state : 
		down_btn.hide()
		up_btn.show()
	else:
		up_btn.hide()
		down_btn.show()


func _on_btn_up_area_area_entered(area: Area2D) -> void:
	var elem_contact = area.get_parent()
	if elem_contact is Player: 
		level_door.open_door.emit()
		btn_state = false


func _on_btn_down_area_area_entered(area: Area2D) -> void:
	var elem_contact = area.get_parent()
	if elem_contact is Player: 
		btn_state = false 
