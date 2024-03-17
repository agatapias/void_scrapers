extends AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("finished", _on_loop_sound)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_loop_sound():
	play(0.0)
