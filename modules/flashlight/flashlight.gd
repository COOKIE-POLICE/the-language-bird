extends Item

var battery_life: float = 100.0

func _process(delta: float) -> void:
	%BatteryLife.value = battery_life

func toggle_flashlight() -> void:
	%FlashlightClickAudio.play()
	if %Light.visible:
		%Light.hide()
		%FlashlightBatteryDrainTimer.set_paused(true)
	elif !%Light.visible and battery_life > 0:
		%Light.show()
		%FlashlightBatteryDrainTimer.set_paused(false)

func set_battery_life(value: float) -> void:
	battery_life = value


func _on_flashlight_battery_drain_timer_timeout() -> void:
	if visible and battery_life > 0:
		battery_life -= 1
	if battery_life <= 0:
		%Light.hide()
