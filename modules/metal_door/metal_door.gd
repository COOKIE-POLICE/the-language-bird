extends Node3D

var is_open = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func toggle_door() -> void:
	if is_open:
		animation_player.play("close")
		is_open = false
	else:
		animation_player.play("open")
		is_open = true
		
