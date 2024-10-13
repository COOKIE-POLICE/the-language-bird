extends Node3D

var battery_life: float = 100.0


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_flashlight") and visible:
		%FlashlightClickAudio.play()
		if %Light.visible:
			%Light.hide()
			%FlashlightBatteryDrainTimer.set_paused(true)
		else:
			%Light.show()
			%FlashlightBatteryDrainTimer.set_paused(false)
	%BatteryLife.value = battery_life


func set_battery_life(value: float) -> void:
	battery_life = value


func _on_flashlight_battery_drain_timer_timeout() -> void:
	if visible:
		battery_life -= 1
