extends RigidBody3D

@export_multiline var text: String

func _ready() -> void:
	%NoteText.text = text
func _process(delta: float) -> void:
	print("ok")
	if Input.is_action_just_pressed("close_note"):
		%Note.hide()

func show_note() -> void:
	%Note.show()
