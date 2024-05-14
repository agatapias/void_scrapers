extends Control

@onready var inventory_ui: Control = get_node("../Inventory_UI")
@onready var shop_ui: Control = get_node("../ShopUi")
@onready var help_ui: Control = get_node("../Help")

var isOpen = false

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	$NinePatchRect/ContinueButton.buttonPressed.connect(onContinueButtonClicked)
	$NinePatchRect/ExitButton.buttonPressed.connect(onExitButtonClicked)
	$NinePatchRect/HelpButton.buttonPressed.connect(onHelpButtonClicked)
	close()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("escape"):
		close()
		
	if Input.is_action_just_pressed("pause"):
		if isOpen: close()
		else: open()
		
func close():
	get_tree().paused = false
	visible = false
	isOpen = false
	
func open():
	inventory_ui.close()
	shop_ui.close()
	get_tree().paused = true
	visible = true
	isOpen = true

func onContinueButtonClicked():
	close()
	
func onExitButtonClicked():
	get_tree().quit()
	
func onHelpButtonClicked():
	close()
	help_ui.open()
