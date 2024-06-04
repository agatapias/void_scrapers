extends Node

@export var scenes = {
		
}

var data

# Called when the node enters the scene tree for the first time.
func _ready():
	var scene = scenes['Menu'].instantiate()
	add_child(scene)
	$StartMenu.transition.connect(callbackForScene)
	$TransitionLayer.transitioned.connect(callback)

func callbackForScene(_data):
	$TransitionLayer.transition()
	data = _data
 
func callback():
	for child in get_children():
		if child.name != 'TransitionLayer':
			remove_child(child)

	var scene = scenes[data.level_node].instantiate()
	add_child(scene)
	var spaceship = scene.get_node('Spaceship')
	if data.health != null:
		spaceship._health = data.health
	if data.items != null:
		spaceship.inventory.items = data.items
	var node = scene.get_node("LevelTransition")
	if node != null:
		node.transition.connect(callbackForScene)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
