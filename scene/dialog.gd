extends Control

var isOpen = false

# Called when the node enters the scene tree for the first time.
func _ready():
	close()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if Input.is_action_just_pressed("escape"):
		#close()
	pass


func close():
	get_tree().paused = false
	visible = false
	$NinePatchRect.visible = false
	isOpen = false
	
	
func open():
	get_tree().paused = true
	visible = true
	$NinePatchRect.visible = true
	isOpen = true


func setText(str):
	$Text.text = str
