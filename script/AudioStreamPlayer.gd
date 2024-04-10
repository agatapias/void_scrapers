extends AudioStreamPlayer

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	connect("finished", _on_loop_sound)
	play(0.0)

func _on_loop_sound():
	play(0.0)
