@icon("res://assets/editor_icons/flashlight.svg")
extends RigidBody3D
class_name Item



func on_drop() -> void:
	freeze = false

func on_pick_up() -> void:
	freeze = true
