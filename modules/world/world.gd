extends Node3D
class_name World

@onready var world: SubViewport = $WorldContainer/World
@export var ambience: AudioStream

var total_time_seconds = 0

func _on_timer_timeout() -> void:
	total_time_seconds += 1
	Global.minutes = int(total_time_seconds/60)
	Global.seconds = total_time_seconds - Global.minutes * 60
