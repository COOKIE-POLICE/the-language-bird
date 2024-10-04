extends CharacterBody3D


const SPEED: float = 5.0
var sensitivity: float = 0.002
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y = rotation.y - event.relative.x * sensitivity
		%Camera3D.rotation.x = %Camera3D.rotation.x - event.relative.y * sensitivity
		%Camera3D.rotation.x = clamp(%Camera3D.rotation.x, deg_to_rad(-70), deg_to_rad(80))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif Input.is_action_just_pressed("switch_to_flashlight"):
		%Flashlight.show()
		%Glock.hide()
	elif Input.is_action_just_pressed("switch_to_pistol"):
		%Flashlight.hide()
		%Glock.show()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	move_and_slide()
