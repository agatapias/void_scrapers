extends AudioStreamPlayer

func _ready():
	connect("finished", _on_loop_sound)
	play(0.0)

func _on_loop_sound():
	play(0.0)
