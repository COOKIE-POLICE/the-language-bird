extends Node3D

@export var is_open = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var door_name: String
func toggle_door() -> void:
	if is_open:
		if not animation_player.is_playing():
			animation_player.play("close")
	else:
		if not animation_player.is_playing():
			animation_player.play("open")
		
