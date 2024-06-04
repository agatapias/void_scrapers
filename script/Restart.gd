extends Button

var spaceship

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	spaceship = get_tree().get_nodes_in_group("Spaceship")[0] #get_node('../../../../Spaceship')
	pressed.connect(_button_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _button_pressed():
	get_tree().paused = false
	spaceship.restore()
	var game_over = get_tree().get_first_node_in_group("GameOverScreen")# get_node("../../../UILayer/GameOverScreen")
	game_over.visible = false
	
