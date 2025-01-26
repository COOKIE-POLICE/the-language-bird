extends Control
class_name WorldUI
@onready var crosshair: TextureRect = $Crosshair
@onready var interacting_label: Label = $InteractingLabel
@onready var battery_life: ProgressBar = $BatteryLife
@onready var radial_progress_bar: ColorRect = $RadialProgressBar

var value: float = 0.0
var max_value: float = 100.0
var min_value: float = 0.0
func _process(delta: float) -> void:
	set_radial_progress_bar_value(value)


func set_radial_progress_bar_value(new_value: float) -> void:
	value = clamp(new_value, min_value, max_value)
	radial_progress_bar.material.set_shader_parameter("value", value/max_value)
