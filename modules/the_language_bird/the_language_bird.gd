extends CharacterBody3D
class_name TheLanguageBird

@onready var kill_zone: Area3D = $KillZone
@onready var nav_agent: NavigationAgent3D = $NavAgent
@onready var state_chart: StateChart = $StateChart

var direction: Vector3
var movement_speed: float
var patrol_global_positions: Array[Vector3]
var player: Player

func init_player() -> void:
	player = get_tree().get_first_node_in_group("players")

func init_patrol_global_positions() -> void:
	for node in get_tree().get_nodes_in_group("patrol_markers"):
		patrol_global_positions.append(node.global_position)

func _ready() -> void:
	init_patrol_global_positions()
	init_player()


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta * 100


func _physics_process(delta: float) -> void:
	if NavigationServer3D.map_get_iteration_id(nav_agent.get_navigation_map()) == 0:
		return
	var next_path_position: Vector3 = nav_agent.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * movement_speed
	if nav_agent.avoidance_enabled:
		nav_agent.set_velocity(new_velocity)
	else:
		_on_nav_agent_velocity_computed(new_velocity)
	apply_gravity(delta)
	move_and_slide()
	check_and_eliminate_player()


func check_and_eliminate_player() -> void:
	for body in kill_zone.get_overlapping_bodies():
		if body is Player:
			get_tree().change_scene_to_file("res://modules/game_over/game_over.tscn")


func check_nav_finished() -> bool:
	return nav_agent.is_navigation_finished()


func set_movement_target(pos: Vector3) -> void:
	nav_agent.set_target_position(pos)
	look_at(pos)
	rotate_y(deg_to_rad(180))
	rotation.x = 0


func _on_nav_agent_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
	move_and_slide()
