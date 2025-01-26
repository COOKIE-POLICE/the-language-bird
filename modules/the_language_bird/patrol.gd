extends Node

# Remember: when patrol state is paused, so is the timer
@onready var state_chart: StateChart = $"../../.."
@onready var the_language_bird: TheLanguageBird = $"../../../.."


func _on_angry_zone_body_entered(body: Node3D) -> void:
	if body is Player:
		state_chart.send_event("angry_zone_entered")


func _on_timer_timeout() -> void:
	if the_language_bird.check_nav_finished():
		if !the_language_bird.patrol_global_positions:
			return
		var random_patrol_global_position: Vector3 = the_language_bird.patrol_global_positions.pick_random()
		the_language_bird.set_movement_target(random_patrol_global_position)


func _on_patrol_state_entered() -> void:
	the_language_bird.movement_speed = 1.5
