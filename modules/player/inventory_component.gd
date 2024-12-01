extends Node

var inventory_slots: Dictionary = {1: null, 2: null, 3: null}
var current_inventory_slot: int = 1

# These dictionaries are to design how the items will look in first-person viewport
var item_positions: Dictionary = {
	"flashlight": Vector3(0.4, 0.2, -1),
	"key": Vector3(0.4, 0.2, -1.3)
}
var item_rotation_degrees: Dictionary = {
	"flashlight": Vector3(-90, 0, 0),
	"key": Vector3(0, 90, 0)
}
@onready var hand: Node3D = $"../Head/Hand"

func switch_inventory_slot(inventory_slot: int) -> void:
	if inventory_slots[current_inventory_slot] != null:
		inventory_slots[current_inventory_slot].hide()
	current_inventory_slot = inventory_slot
	if inventory_slots[current_inventory_slot] != null:
		inventory_slots[current_inventory_slot].show()
	_set_current_slot_transform()
func drop() -> void:
	if inventory_slots[current_inventory_slot] != null:
		inventory_slots[current_inventory_slot].reparent(get_tree().current_scene.world)
		if inventory_slots[current_inventory_slot] is Item:
			inventory_slots[current_inventory_slot].on_drop()
		inventory_slots[current_inventory_slot] = null

func _set_current_slot_transform() -> void:
	if inventory_slots[current_inventory_slot] == null:
		return
	if is_current_slot_in_group("flashlights"):
		inventory_slots[current_inventory_slot].position = item_positions["flashlight"]
		inventory_slots[current_inventory_slot].rotation_degrees = item_rotation_degrees["flashlight"]
	elif is_current_slot_in_group("keys"):
		inventory_slots[current_inventory_slot].position = item_positions["key"]
		inventory_slots[current_inventory_slot].rotation_degrees = item_rotation_degrees["key"]

func pick_up(body: Node3D) -> void:
	body.on_pick_up()
	body.reparent(hand)
	inventory_slots[current_inventory_slot] = body
	_set_current_slot_transform()

func is_current_slot_in_group(group_name: String) -> bool:
	if inventory_slots[current_inventory_slot] != null:
		return inventory_slots[current_inventory_slot].is_in_group(group_name)
	return false

func get_current_inventory_slot() -> Node3D:
	return inventory_slots[current_inventory_slot]
