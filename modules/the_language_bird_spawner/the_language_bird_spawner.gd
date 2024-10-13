extends Node3D

const THE_LANGUAGE_BIRD: PackedScene = preload(
	"res://modules/the_language_bird/the_language_bird.tscn"
)


func _on_spawn_timer_timeout() -> void:
	var the_language_bird: TheLanguageBird = THE_LANGUAGE_BIRD.instantiate()
	get_tree().current_scene.add_child(the_language_bird)
	the_language_bird.position = position
