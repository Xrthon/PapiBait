class_name Trigger
extends Node2D

signal triggered

@export var one_shot := true
@export var saw : Saw 
@export var rock_trap : RockTrap 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		triggered.emit()
		print("le joueur est:",  body.global_position)
		if saw: 
			saw.activate()
		if rock_trap: 
			rock_trap.activate()
		
	pass # Replace with function body.
