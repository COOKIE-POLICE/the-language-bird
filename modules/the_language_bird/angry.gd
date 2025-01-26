extends Node

@onready var the_language_bird: TheLanguageBird = $"../../../.."
@onready var state_chart: StateChart = $"../../.."
@onready var audio: AudioStreamPlayer3D = $"../Audio"


func _on_angry_zone_body_exited(body: Node3D) -> void:
	if body is Player:
		state_chart.send_event("angry_zone_exited")


func _on_timer_timeout() -> void:
	the_language_bird.set_movement_target(the_language_bird.player.position)


func _on_angry_state_entered() -> void:
	the_language_bird.movement_speed = 3.0
	audio.play()


func _on_angry_state_exited() -> void:
	audio.stop()
