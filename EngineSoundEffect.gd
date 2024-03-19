extends AudioStreamPlayer2D

func _ready():
	connect("finished", _on_loop_sound)

func _on_loop_sound():
	play(0.0)
