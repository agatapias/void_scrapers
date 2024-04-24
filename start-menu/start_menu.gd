extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	$ContinueButton.buttonPressed.connect(onPlayButtonClicked)
	$ExitButton.buttonPressed.connect(onExitButtonClicked)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func onPlayButtonClicked():
	pass
	
func onExitButtonClicked():
	get_tree().quit()
