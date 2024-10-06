extends CharacterBody3D
class_name TheLanguageBird
@export var player: Player
var speed: float = 2.0

func _physics_process(delta: float) -> void:
	set_movement_target()
	if not is_on_floor():
		velocity += get_gravity() * delta * 100
	if NavigationServer3D.map_get_iteration_id(%NavigationAgent3D.get_navigation_map()) == 0:
		return
	if %NavigationAgent3D.is_navigation_finished():
		return
	var destination: Vector3 = %NavigationAgent3D.get_next_path_position()
	var local_destination: Vector3 = destination - global_position
	var direction = local_destination.normalized()
	velocity = direction * speed
	move_and_slide()

func set_movement_target() -> void:
	%NavigationAgent3D.set_target_position(player.position)
	look_at(player.global_transform.origin)
	rotate_y(deg_to_rad(180))
	rotation.x = 0


func _on_enemy_range_body_entered(body: Node3D) -> void:
	if body.is_in_group("players"):
		speed = 1.0
