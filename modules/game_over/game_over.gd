extends Control
@onready var time: Label = $Time

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://modules/world/world.tscn")


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://modules/main_menu/main_menu.tscn")

func _process(delta: float) -> void:
	time.text = "%d:%d" % [Global.minutes, Global.seconds]
