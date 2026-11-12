class_name RockTrap
extends Node2D


func activate() -> void:
	for child in get_children():
		if child.has_method("activate"):
			child.activate()

func deactivate() -> void:
	for child in get_children():
		if child.has_method("deactivate"):
			child.deactivate()
