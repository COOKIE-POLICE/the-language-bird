extends Control

@onready var animation_player: AnimationPlayer = $Background/Camera3D/AnimationPlayer

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta: float) -> void:
	animation_player.play("side_to_side")
	


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://modules/world/world.tscn")


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://modules/credits/credits.tscn")
