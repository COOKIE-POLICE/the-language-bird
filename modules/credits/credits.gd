extends Control


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://modules/main_menu/main_menu.tscn")
