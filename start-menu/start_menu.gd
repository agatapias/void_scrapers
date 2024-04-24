extends Node2D

signal transition

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	$ContinueButton.buttonPressed.connect(onPlayButtonClicked)
	$ExitButton.buttonPressed.connect(onExitButtonClicked)


func onPlayButtonClicked():
	var data = {level = "main.tscn", level_node = "Main", items = null, health = null}
	transition.emit(data)
	
func onExitButtonClicked():
	get_tree().quit()
