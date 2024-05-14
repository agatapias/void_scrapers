extends Control

var isOpen = false

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	$NinePatchRect/ExitButton.buttonPressed.connect(close)
	close()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("escape"):
		close()


func close():
	get_tree().paused = false
	visible = false
	isOpen = false
	
	
func open():
	get_tree().paused = true
	visible = true
	isOpen = true
