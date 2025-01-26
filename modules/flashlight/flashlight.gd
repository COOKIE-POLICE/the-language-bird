extends Item

var battery_life: float = 100.0
var world_ui: WorldUI

func init_world_ui() -> void:
	world_ui = get_tree().get_first_node_in_group("world_ui")

func _ready() -> void:
	init_world_ui()

func _process(delta: float) -> void:
	world_ui.battery_life.value = battery_life
	if get_parent() is PlayerHand and visible:
		world_ui.battery_life.show()
	else:
		world_ui.battery_life.hide()

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
