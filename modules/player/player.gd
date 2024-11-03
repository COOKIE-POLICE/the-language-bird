extends CharacterBody3D
class_name Player

@onready var hand: Node3D = $Head/Hand

const SPEED: float = 5.0
var sensitivity: float = 0.008
@onready var default_hand_position: Vector3 = hand.position
var bob_amount_walking: Vector2 = Vector2(0.01, 0.01)
var bob_freq_walking: Vector2 = Vector2(0.005, 0.01)
var bob_amount_idle: Vector2 = Vector2(0.004, 0.004)
var bob_freq_idle: Vector2 = Vector2(0.004, 0.004)
var can_move: bool = true
@onready var head: Node3D = $Head
@onready var interacting_area: Area3D = $InteractingArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interacting_label: Label = $InteractingLabel

var item_positions: Dictionary = {
	"flashlight": Vector3(0.4, 0.2, -1), 
	"key": Vector3(0.4, 0.2, -1.3)
}
var item_rotations: Dictionary = {
	"flashlight": Vector3(-90, 0, 0), 
	"key": Vector3(0, 90, 0)
}
var slots: Dictionary = {1: null, 2: null, 3: null}
var current_slot: int = 1

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and can_move:
		rotation.y = rotation.y - event.relative.x * sensitivity
		head.rotation.x = head.rotation.x - event.relative.y * sensitivity
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-70), deg_to_rad(80))


func _weapon_bob(delta: float) -> void:
	if velocity != Vector3.ZERO:
		hand.position.y = lerp(
			hand.position.y,
			(
				default_hand_position.y
				+ sin(Time.get_ticks_msec() * bob_freq_walking.y) * bob_amount_walking.y
			),
			10 * delta
		)
		hand.position.x = lerp(
			hand.position.x,
			(
				default_hand_position.x
				+ sin(Time.get_ticks_msec() * bob_freq_walking.x) * bob_amount_walking.x
			),
			10 * delta
		)
	else:
		hand.position.y = lerp(
			hand.position.y,
			(
				default_hand_position.y
				+ sin(Time.get_ticks_msec() * bob_freq_idle.y) * bob_amount_idle.y
			),
			10 * delta
		)
		hand.position.x = lerp(
			hand.position.x,
			(
				default_hand_position.x
				+ sin(Time.get_ticks_msec() * bob_freq_idle.x) * bob_amount_idle.x
			),
			10 * delta
		)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif Input.is_action_just_pressed("switch_to_slot_one"):
		_switch_slot(1)
		_set_current_slot_transform()
	elif Input.is_action_just_pressed("switch_to_slot_two"):
		_switch_slot(2)
		_set_current_slot_transform()
	elif Input.is_action_just_pressed("switch_to_slot_three"):
		_switch_slot(3)
		_set_current_slot_transform()
	elif Input.is_action_just_pressed("drop") and _is_current_slot_occupied():
		if slots[current_slot] is Item:
			slots[current_slot].reparent(get_tree().current_scene.world)
			slots[current_slot].on_drop()
			slots[current_slot] = null
	elif Input.is_action_just_pressed("toggle_flashlight") and _is_current_slot_in_group("flashlights"):
		if slots[current_slot].is_in_group("flashlights"):
			slots[current_slot].toggle_flashlight()

func _physics_process(delta: float) -> void:
	check_interaction()
	if not is_on_floor():
		velocity += get_gravity() * delta
	if can_move:
		var input_dir: Vector2 = Input.get_vector(
			"move_left", "move_right", "move_forward", "move_backward"
		)
		var direction: Vector3 = (
			(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		_weapon_bob(delta)
	if velocity.z != 0 or velocity.x != 0:
		animation_player.play("walk")
	move_and_slide()


func _show_interacting_label(text: String):
	interacting_label.text = text
	interacting_label.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	interacting_label.position.y - 50
	interacting_label.show()

func check_interaction() -> void:
	interacting_label.hide()
	
	if interacting_area.has_overlapping_bodies():
		for body in interacting_area.get_overlapping_bodies():
			if body.is_in_group("batteries"):
				_show_interacting_label("Press E to Replace Flashlight Battery")
				if Input.is_action_just_pressed("interact") and slots[current_slot] != null:
					if slots[current_slot].is_in_group("flashlights"):
						slots[current_slot].set_battery_life(100)
						body.queue_free()
				break
			elif body.is_in_group("notes"):
				_show_interacting_label("Press E To Read Note")
				if Input.is_action_just_pressed("interact"):
					body.show_note()
				break
			elif body is Item and body not in slots.values() and _is_current_slot_not_occupied():
				if body.is_in_group("flashlights"):
					_show_interacting_label("Press E To Pick Up Flashlight")
				elif body.is_in_group("keys"):
					_show_interacting_label("Press E To Pick Up Key")
				if Input.is_action_just_pressed("interact"):
					body.on_pick_up()
					body.reparent(hand)
					slots[current_slot] = body
					_set_current_slot_transform()
				break

func _set_current_slot_transform() -> void:
	if _is_current_slot_not_occupied():
		return
	if slots[current_slot].is_in_group("flashlights"):
		slots[current_slot].position = item_positions["flashlight"]
		slots[current_slot].rotation_degrees = item_rotations["flashlight"]
	elif slots[current_slot].is_in_group("keys"):
		slots[current_slot].position = item_positions["key"]
		slots[current_slot].rotation_degrees = item_rotations["key"]

func _is_current_slot_not_occupied() -> bool:
	return slots[current_slot] == null

func _is_current_slot_in_group(group_name: String) -> bool:
	if slots[current_slot] != null:
		return slots[current_slot].is_in_group(group_name)
	return false

func _is_current_slot_occupied() -> bool:
	return slots[current_slot] != null

func _switch_slot(slot_number: int) -> void:
	current_slot = slot_number
	for child in hand.get_children():
		child.hide()	
	if slots[slot_number] != null:
		slots[slot_number].show()
