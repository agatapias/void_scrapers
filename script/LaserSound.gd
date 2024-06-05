extends AudioStreamPlayer2D

func _ready():
	play(0.0)
	connect("finished", _on_loop_sound)

func _process(delta):
	if not get_parent().visible:
		playing = false
	else:
		playing = true

func _on_loop_sound():
	play(0.0)
