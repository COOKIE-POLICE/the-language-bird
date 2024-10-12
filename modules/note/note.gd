extends RigidBody3D

@export_multiline var text: String

func _ready() -> void:
	%NoteText.text = text

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("close_note"):
		if %Note.visible:
			%Note.hide()
			%PaperCrackleAudio.play()
			get_tree().get_first_node_in_group("players").can_move = true
func show_note() -> void:
	if !%Note.visible:
		%Note.show()
		%PaperCrackleAudio.play()
		get_tree().get_first_node_in_group("players").can_move = false
